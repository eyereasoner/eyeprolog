// Shared synchronous worker transport for the Node-only library host adapters.
//
// library(http) and library(sockets) both need Node's asynchronous I/O from
// inside EyeProlog's synchronous solver, and both answer it the same way: a
// worker thread owns the asynchronous API while the calling thread blocks on
// Atomics over a SharedArrayBuffer.  Only the request vocabulary and the
// failure translation differ between them, so the transport lives here and
// each host adapter supplies its own errors.  Keeping one copy of the
// handshake also keeps one copy of its subtleties: the worker signals
// readiness by storing -1, and an unref'd worker must never keep the process
// alive on its own.

import { isNode } from './platform.js';

let WorkerCtor = null;
if (isNode) ({ Worker: WorkerCtor } = await import('node:worker_threads'));

const HEADER_WORDS = 4;
const READY_TIMEOUT_MS = 5000;

// Atomics.wait is only available on a SharedArrayBuffer, and neither is
// guaranteed outside Node (the playground worker build, for instance).
function transportAvailable() {
  return isNode && WorkerCtor != null &&
    typeof SharedArrayBuffer !== 'undefined' && typeof Atomics?.wait === 'function';
}

class WorkerBridge {
  constructor(moduleUrl, rpcBytes, errors) {
    this.errors = errors;
    this.shared = new SharedArrayBuffer(HEADER_WORDS * Int32Array.BYTES_PER_ELEMENT + rpcBytes);
    this.header = new Int32Array(this.shared, 0, HEADER_WORDS);
    this.bytes = new Uint8Array(this.shared, HEADER_WORDS * Int32Array.BYTES_PER_ELEMENT);
    this.encoder = new TextEncoder();
    this.decoder = new TextDecoder();
    this.worker = new WorkerCtor(moduleUrl, {
      type: 'module', workerData: { shared: this.shared },
      execArgv: typeof process !== 'undefined' ? process.execArgv.filter((arg) => !arg.startsWith('--input-type')) : [],
    });
    this.worker.unref();
    const ready = Atomics.wait(this.header, 0, 0, READY_TIMEOUT_MS);
    if (ready === 'timed-out' || Atomics.load(this.header, 0) !== -1) {
      this.worker.terminate();
      throw errors.unavailable();
    }
    Atomics.store(this.header, 0, 0);
  }

  rpc(request) {
    const encoded = this.encoder.encode(JSON.stringify(request));
    if (encoded.length > this.bytes.length) throw this.errors.oversized();
    this.bytes.set(encoded, 0);
    Atomics.store(this.header, 1, encoded.length);
    Atomics.store(this.header, 2, 0);
    Atomics.store(this.header, 0, 1);
    this.worker.postMessage(1);
    Atomics.wait(this.header, 0, 1);
    const responseLength = Atomics.load(this.header, 2);
    const response = JSON.parse(this.decoder.decode(this.bytes.subarray(0, responseLength)));
    Atomics.store(this.header, 0, 0);
    if (!response.ok) throw this.errors.failed(response.error);
    return response.result;
  }
}

// Returns the accessor each host adapter calls per operation.  The worker
// starts on first use and is then reused for the lifetime of the process, so
// a program that never touches the library never pays for its thread.
//
// `errors` supplies the three failures the transport itself can raise:
// `unavailable()` when the platform or the worker handshake cannot provide the
// service at all, `oversized()` when a request does not fit the RPC buffer,
// and `failed(error)` to translate a worker-reported failure.
export function workerBridgeAccessor(moduleUrl, rpcBytes, errors) {
  let bridge = null;
  return () => {
    if (!transportAvailable()) throw errors.unavailable();
    bridge ??= new WorkerBridge(moduleUrl, rpcBytes, errors);
    return bridge;
  };
}
