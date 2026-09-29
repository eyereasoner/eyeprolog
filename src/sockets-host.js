// Node TCP services for Scryer-compatible library(sockets).
// The public Prolog module stays synchronous; a worker owns Node's asynchronous
// sockets and the host adapter bridges each operation into the existing stream API.

import { PrologError } from './errors.js';
import {
  ATOM, COMPOUND, NUMBER, VAR, atom, compound, copyResolved, deref, numberTerm,
  properListItems, unify,
} from './term.js';
import { workerBridgeAccessor } from './worker-bridge.js';

const RPC_BYTES = 1024 * 1024;
const WRITE_CHUNK_BYTES = 256 * 1024;

// Socket failures stay ordinary JavaScript errors carrying the Node errno;
// socketSystemError below maps each operation's errno to its Prolog error.
const socketBridge = workerBridgeAccessor(new URL('./sockets-worker.js', import.meta.url), RPC_BYTES, {
  unavailable: () => new PrologError('resource_error(sockets)'),
  oversized: () => new PrologError('resource_error(socket_message)'),
  failed: (error) => {
    const failure = new Error(error?.message ?? 'socket error');
    failure.code = error?.code ?? 'EUNKNOWN';
    return failure;
  },
});

function socketSystemError(error, operation, culprit = null) {
  if (error instanceof PrologError) return error;
  if (error?.code === 'EACCES' || error?.code === 'EPERM') {
    return new PrologError('permission_error(open, source_sink)', culprit);
  }
  if (error?.code === 'EBADF') return new PrologError('existence_error(socket)', culprit);
  if (['ECONNREFUSED', 'EHOSTUNREACH', 'ENETUNREACH', 'ENOTFOUND', 'EADDRNOTAVAIL'].includes(error?.code)) {
    return new PrologError('existence_error(source_sink)', culprit);
  }
  if (error?.code === 'EADDRINUSE') return new PrologError('permission_error(open, source_sink)', culprit);
  return new PrologError(`resource_error(${operation})`, culprit);
}

function optionsList(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  const items = properListItems(value, env);
  if (items == null) throw new PrologError('type_error(list)', copyResolved(value, env));
  return items.map((item) => deref(item, env));
}

function parseSocketOptions(term, env) {
  const result = { alias: null, eofAction: 'error', reposition: false, type: 'text' };
  for (const option of optionsList(term, env)) {
    if (option.type === VAR) throw new PrologError('instantiation_error');
    if (option.type !== COMPOUND || option.arity !== 1) throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
    const value = deref(option.args[0], env);
    if (value.type === VAR) throw new PrologError('instantiation_error');
    if (option.name === 'alias') {
      if (value.type !== ATOM) throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
      result.alias = value.name;
    } else if (option.name === 'eof_action') {
      if (value.type !== ATOM || !['error', 'eof_code', 'reset'].includes(value.name)) {
        throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
      }
      result.eofAction = value.name;
    } else if (option.name === 'reposition') {
      if (value.type !== ATOM || !['true', 'false'].includes(value.name)) {
        throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
      }
      result.reposition = value.name === 'true';
    } else if (option.name === 'type') {
      if (value.type !== ATOM || !['text', 'binary'].includes(value.name)) {
        throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
      }
      result.type = value.name;
    } else {
      throw new PrologError('domain_error(stream_option)', copyResolved(option, env));
    }
  }
  return result;
}

function hostText(term, env, { allowEmptyList = false } = {}) {
  const value = deref(term, env);
  if (allowEmptyList && value.type === ATOM && value.name === '[]') return '127.0.0.1';
  if (value.type !== ATOM) throw new PrologError('type_error(atom)', copyResolved(value, env));
  return value.name;
}

function portValue(term, env, { allowVariable = false } = {}) {
  const value = deref(term, env);
  if (allowVariable && value.type === VAR) return { port: 0, variable: true };
  if (value.type === NUMBER && /^\d+$/.test(value.name)) {
    const port = Number(value.name);
    if (Number.isInteger(port) && port >= 0 && port <= 65535) return { port, variable: false };
  }
  if (!allowVariable && value.type === ATOM && /^\d+$/.test(value.name)) {
    const port = Number(value.name);
    if (port <= 65535) return { port, variable: false };
  }
  throw new PrologError('type_error(integer)', copyResolved(value, env));
}

function serverHandle(id) {
  return compound('$socket_server', [numberTerm(id)]);
}

function serverId(term, env) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === COMPOUND && value.name === '$socket_server' && value.arity === 1) {
    const id = deref(value.args[0], env);
    if (id.type === NUMBER && /^\d+$/.test(id.name)) return Number(id.name);
  }
  throw new PrologError('type_error(socket)', copyResolved(value, env));
}

function base64(bytes) {
  return Buffer.from(bytes).toString('base64');
}

function bytesFromBase64(text) {
  return Uint8Array.from(Buffer.from(text, 'base64'));
}

function addSocketStream(solver, connectionId, options, fileName = '') {
  if (options.reposition) throw new PrologError('permission_error(reposition, stream)');
  if (options.alias && solver.io.resolve(options.alias)) {
    throw new PrologError('permission_error(open, source_sink)', compound('alias', [atom(options.alias)]));
  }
  const worker = socketBridge();
  const textDecoder = options.type === 'text' ? new TextDecoder('utf-8', { fatal: true }) : null;
  const stream = {
    id: solver.io.nextId++, alias: options.alias, mode: 'read_append', type: options.type,
    content: options.type === 'binary' ? [] : '', position: 0, reportedPosition: 0, path: fileName,
    reposition: false, eofAction: options.eofAction, standard: false, pastEnd: false,
    readable: true, writable: true, remoteEnded: false, continuousRefill: true,
    socketConnectionId: connectionId,
    socketOutput: options.type === 'binary' ? [] : '',
  };
  stream.interactiveReadUnit = () => {
    while (true) {
      let result;
      try { result = worker.rpc({ op: 'read', connectionId, maxBytes: 64 * 1024 }); }
      catch (error) { throw socketSystemError(error, 'socket_read'); }
      if (result.eof) {
        stream.remoteEnded = true;
        if (stream.type === 'text') {
          try {
            const tail = textDecoder.decode();
            if (tail) return tail;
          } catch (_) {
            throw new PrologError('representation_error(character)');
          }
        }
        return null;
      }
      const bytes = bytesFromBase64(result.data);
      if (stream.type === 'binary') return [...bytes];
      let text;
      try { text = textDecoder.decode(bytes, { stream: true }); }
      catch (_) { throw new PrologError('representation_error(character)'); }
      if (text.length > 0) return text;
    }
  };
  stream.writeUnit = (value) => {
    if (stream.type === 'binary') stream.socketOutput.push(value);
    else stream.socketOutput += String(value);
  };
  stream.flush = () => {
    const data = stream.type === 'binary'
      ? Uint8Array.from(stream.socketOutput)
      : new TextEncoder().encode(stream.socketOutput);
    if (data.length === 0) return;
    for (let offset = 0; offset < data.length; offset += WRITE_CHUNK_BYTES) {
      const chunk = data.subarray(offset, Math.min(data.length, offset + WRITE_CHUNK_BYTES));
      try { worker.rpc({ op: 'write', connectionId, data: base64(chunk) }); }
      catch (error) { throw socketSystemError(error, 'socket_write'); }
    }
    stream.socketOutput = stream.type === 'binary' ? [] : '';
  };
  stream.closeTransport = () => {
    try { worker.rpc({ op: 'close', connectionId }); }
    catch (error) { throw socketSystemError(error, 'socket_close'); }
  };
  solver.io.add(stream);
  return stream;
}

function streamHandle(id) {
  return compound('$stream', [numberTerm(id)]);
}

function* socketClientOpenBuiltin({ solver, goal, env }) {
  const host = hostText(goal.args[0], env);
  const { port } = portValue(goal.args[1], env);
  const options = parseSocketOptions(goal.args[3], env);
  if (options.reposition) throw new PrologError('permission_error(reposition, stream)', copyResolved(goal.args[3], env));
  let result;
  try { result = socketBridge().rpc({ op: 'client_open', host, port }); }
  catch (error) { throw socketSystemError(error, 'socket_client_open', copyResolved(goal.args[0], env)); }
  const stream = addSocketStream(solver, result.connectionId, options, `${host}:${port}`);
  const next = env.clone();
  if (unify(goal.args[2], streamHandle(stream.id), next)) yield next;
  else solver.io.close(stream);
}

function* socketServerOpenBuiltin({ goal, env }) {
  const host = hostText(goal.args[0], env, { allowEmptyList: true });
  const { port, variable } = portValue(goal.args[1], env, { allowVariable: true });
  let result;
  try { result = socketBridge().rpc({ op: 'server_open', host, port }); }
  catch (error) { throw socketSystemError(error, 'socket_server_open', copyResolved(goal.args[0], env)); }
  const next = env.clone();
  if (!unify(goal.args[2], serverHandle(result.serverId), next) ||
      (variable && !unify(goal.args[1], numberTerm(result.port), next))) {
    try { socketBridge().rpc({ op: 'server_close', serverId: result.serverId }); } catch (_) { /* best effort */ }
    return;
  }
  yield next;
}

function* socketServerAcceptBuiltin({ solver, goal, env }) {
  const id = serverId(goal.args[0], env);
  const options = parseSocketOptions(goal.args[3], env);
  if (options.reposition) throw new PrologError('permission_error(reposition, stream)', copyResolved(goal.args[3], env));
  let result;
  try { result = socketBridge().rpc({ op: 'server_accept', serverId: id }); }
  catch (error) { throw socketSystemError(error, 'socket_server_accept', copyResolved(goal.args[0], env)); }
  const stream = addSocketStream(solver, result.connectionId, options, result.client);
  const next = env.clone();
  if (unify(goal.args[1], atom(result.client), next) && unify(goal.args[2], streamHandle(stream.id), next)) yield next;
  else solver.io.close(stream);
}

function* socketServerCloseBuiltin({ goal, env }) {
  const id = serverId(goal.args[0], env);
  try { socketBridge().rpc({ op: 'server_close', serverId: id }); }
  catch (error) { throw socketSystemError(error, 'socket_server_close', copyResolved(goal.args[0], env)); }
  yield env;
}

function* currentHostnameBuiltin({ goal, env }) {
  let result;
  try { result = socketBridge().rpc({ op: 'hostname' }); }
  catch (error) { throw socketSystemError(error, 'current_hostname'); }
  const next = env.clone();
  if (unify(goal.args[0], atom(result.hostname), next)) yield next;
}

export const socketsHostBuiltins = {
  register(registry) {
    registry.add('eyeprolog__socket_client_open', 4, socketClientOpenBuiltin, { deterministic: true, eyePrologLibrary: true });
    registry.add('eyeprolog__socket_server_open', 3, socketServerOpenBuiltin, { deterministic: true, eyePrologLibrary: true });
    registry.add('eyeprolog__socket_server_accept', 4, socketServerAcceptBuiltin, { deterministic: true, eyePrologLibrary: true });
    registry.add('eyeprolog__socket_server_close', 1, socketServerCloseBuiltin, { deterministic: true, eyePrologLibrary: true });
    registry.add('eyeprolog__current_hostname', 1, currentHostnameBuiltin, { deterministic: true, eyePrologLibrary: true });
  },
};
