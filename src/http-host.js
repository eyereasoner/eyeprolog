// Node HTTP(S) bridge for library(http). The Prolog module owns option parsing,
// response shaping, and server-side HTTP parsing; this host adapter performs the
// asynchronous client exchange and exposes each response body as a lazy stream.

import { PrologError } from './errors.js';
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR, atom, compound, copyResolved, deref,
  listFromItems, numberTerm, properListItems, unify,
} from './term.js';
import { characterListText, chars } from './host-utils.js';
import { workerBridgeAccessor } from './worker-bridge.js';

const RPC_BYTES = 8 * 1024 * 1024;
const HTTP_READ_BYTES = 64 * 1024;

const httpBridge = workerBridgeAccessor(new URL('./http-worker.js', import.meta.url), RPC_BYTES, {
  unavailable: () => new PrologError('resource_error(http)'),
  oversized: () => new PrologError('resource_error(http_message)'),
  failed: (error) => {
    if (error?.code === 'EPROTONOSUPPORT') return new PrologError('domain_error(http_url_scheme)');
    if (['ENOTFOUND', 'ECONNREFUSED', 'EHOSTUNREACH', 'ENETUNREACH'].includes(error?.code)) {
      return new PrologError('existence_error(source_sink)');
    }
    return new PrologError('resource_error(http)');
  },
});

function textValue(term, env, { allowNumber = false } = {}) {
  const value = deref(term, env);
  if (value.type === VAR) throw new PrologError('instantiation_error');
  if (value.type === ATOM && value.name === '[]') return '';
  if (value.type === ATOM || value.type === STRING || (allowNumber && value.type === NUMBER)) return value.name;
  return characterListText(term, env);
}

function requestBodyValue(term, env) {
  const value = deref(term, env);
  if (value.type === ATOM && value.name === 'no_data') return null;
  if (value.type === COMPOUND && value.name === 'data' && value.arity === 1) {
    return textValue(value.args[0], env);
  }
  throw new PrologError('domain_error(http_data)', copyResolved(term, env));
}

function requestHeadersValue(term, env) {
  const items = properListItems(deref(term, env), env);
  if (items == null) throw new PrologError('type_error(list)', copyResolved(term, env));
  return items.map((entryTerm) => {
    const entry = deref(entryTerm, env);
    if (entry.type !== COMPOUND || entry.name !== 'header' || entry.arity !== 2) {
      throw new PrologError('domain_error(http_header)', copyResolved(entry, env));
    }
    return [textValue(entry.args[0], env), textValue(entry.args[1], env, { allowNumber: true })];
  });
}

function streamHandle(id) { return compound('$stream', [numberTerm(id)]); }

function bytesFromBase64(text) {
  return Uint8Array.from(Buffer.from(text, 'base64'));
}

function addBodyStream(solver, bodyId, finalUrl) {
  const worker = httpBridge();
  // Buffer.toString('utf8'), used by the original eager bridge, replaced malformed
  // input with U+FFFD. Keep that behavior while decoding incrementally.
  const decoder = new TextDecoder('utf-8');
  const stream = {
    id: solver.io.nextId++, alias: null, mode: 'read', type: 'text', content: '',
    position: 0, reportedPosition: 0, path: String(finalUrl ?? ''), reposition: false,
    eofAction: 'eof_code', standard: false, pastEnd: false, readable: true, writable: false,
    remoteEnded: false, continuousRefill: true, httpBodyId: bodyId,
  };
  stream.interactiveReadUnit = () => {
    while (true) {
      const result = worker.rpc({ op: 'body_read', bodyId, maxBytes: HTTP_READ_BYTES });
      if (result.eof) {
        stream.remoteEnded = true;
        const tail = decoder.decode();
        return tail || null;
      }
      const text = decoder.decode(bytesFromBase64(result.data), { stream: true });
      if (text.length > 0) return text;
    }
  };
  stream.closeTransport = () => {
    worker.rpc({ op: 'body_close', bodyId });
  };
  solver.io.add(stream);
  return stream;
}

function* httpOpenBuiltin({ solver, goal, env }) {
  const url = textValue(goal.args[0], env);
  const method = textValue(goal.args[2], env);
  const data = requestBodyValue(goal.args[3], env);
  const requestHeaders = requestHeadersValue(goal.args[5], env);
  const result = httpBridge().rpc({ op: 'request', url, method, data, headers: requestHeaders, redirects: 5 });
  const stream = addBodyStream(solver, result.bodyId, result.finalUrl);
  const headerTerms = result.headers.map(([name, value]) => compound('header', [atom(name), chars(value)]));
  const next = env.clone();
  if (unify(goal.args[1], streamHandle(stream.id), next) &&
      unify(goal.args[4], numberTerm(result.statusCode), next) &&
      unify(goal.args[6], listFromItems(headerTerms), next) &&
      unify(goal.args[7], chars(result.finalUrl), next)) {
    yield next;
  } else {
    solver.io.close(stream);
  }
}

export const httpHostBuiltins = {
  register(registry) {
    registry.add('eyeprolog__http_open', 8, httpOpenBuiltin, { deterministic: true, eyePrologLibrary: true });
  },
};
