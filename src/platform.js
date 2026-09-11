// Runtime-specific capabilities shared by the Node CLI and browser build.
// Keep Node built-ins behind a guarded dynamic import so browser module workers
// can load the reasoner without trying to resolve `node:*` specifiers.
const isNode = typeof process !== 'undefined' && Boolean(process.versions?.node);

let fs = null;
let path = null;
let BufferCtor = null;
let v8 = null;
let vm = null;

if (isNode) {
  ({ default: fs } = await import('node:fs'));
  ({ default: path } = await import('node:path'));
  ({ default: v8 } = await import('node:v8'));
  ({ default: vm } = await import('node:vm'));
  BufferCtor = globalThis.Buffer ?? null;
}

const configuredOldSpaceLimit = configuredOldSpaceBytes();

export { fs, path, BufferCtor, isNode };

export function currentWorkingDirectory() {
  return isNode && typeof process.cwd === 'function' ? process.cwd() : '/';
}

function oldGenerationUsedSize() {
  if (!isNode || typeof v8?.getHeapSpaceStatistics !== 'function') return null;
  return v8.getHeapSpaceStatistics()
    .filter(({ space_name: name }) => name !== 'read_only_space' && !name.startsWith('new_'))
    .reduce((total, { space_used_size: size }) => total + size, 0);
}

export function usedHeapSize() {
  if (isNode && typeof process.memoryUsage === 'function') {
    // --max-old-space-size constrains V8's old generation, not the complete
    // heap reported by process.memoryUsage().heapUsed. Comparing that limit
    // with total heap use makes bursts of collectible new-space objects look
    // like retained memory. Measure the corresponding non-young spaces when
    // an old-space limit was supplied.
    if (configuredOldSpaceLimit != null) {
      const oldGeneration = oldGenerationUsedSize();
      if (oldGeneration != null) return oldGeneration;
    }
    return process.memoryUsage().heapUsed;
  }
  const memory = globalThis.performance?.memory;
  return Number.isFinite(memory?.usedJSHeapSize) ? memory.usedJSHeapSize : null;
}

let forcedGc = null;
let forcedGcUnavailable = false;

// A resource_error(memory) decision reads ambient process heap usage, which
// also includes still-unreclaimed garbage from work that already finished
// (for example a prior query's abandoned search branches). Without this, one
// short-lived, memory-heavy query can leave enough uncollected garbage behind
// that an unrelated, actually-modest query run immediately afterward in the
// same process sees a false positive. Node does not expose a synchronous GC
// by default; this obtains one without requiring the host process to have
// been launched with --expose-gc, so the guard sees genuinely live memory
// before it gives up.
export function forceGarbageCollection() {
  if (!isNode || forcedGcUnavailable) return false;
  try {
    if (forcedGc == null) {
      if (typeof globalThis.gc === 'function') {
        forcedGc = globalThis.gc;
      } else {
        v8.setFlagsFromString('--expose-gc');
        forcedGc = vm.runInNewContext('gc');
        v8.setFlagsFromString('--no-expose-gc');
      }
    }
    forcedGc();
    return true;
  } catch (_) {
    forcedGcUnavailable = true;
    return false;
  }
}

export function memoryStatistics() {
  const stats = {};
  if (isNode && typeof process.memoryUsage === 'function') {
    const memory = process.memoryUsage();
    stats.memory_heap_used_bytes = memory.heapUsed;
    const oldGeneration = oldGenerationUsedSize();
    if (oldGeneration != null) stats.memory_old_generation_used_bytes = oldGeneration;
    stats.memory_guard_used_bytes = configuredOldSpaceLimit != null && oldGeneration != null
      ? oldGeneration
      : memory.heapUsed;
    stats.memory_rss_bytes = memory.rss;
  } else {
    const memory = globalThis.performance?.memory;
    if (Number.isFinite(memory?.usedJSHeapSize)) {
      stats.memory_heap_used_bytes = memory.usedJSHeapSize;
      stats.memory_guard_used_bytes = memory.usedJSHeapSize;
    }
  }
  const softLimit = softHeapLimit();
  const hardLimit = hardHeapLimit();
  if (Number.isFinite(softLimit)) stats.memory_soft_limit_bytes = softLimit;
  if (Number.isFinite(hardLimit)) stats.memory_hard_limit_bytes = hardLimit;
  return stats;
}

export function softHeapLimit() {
  const limit = hardHeapLimit();
  // Leave ample room for the generator stack to unwind and for the top level
  // to construct and print resource_error(memory). Fatal V8 OOMs cannot be
  // caught after the heap limit itself has been reached.
  return Number.isFinite(limit) && limit > 0 ? Math.floor(limit * 0.75) : Infinity;
}

export function hardHeapLimit() {
  let limit = null;
  if (isNode) {
    limit = v8?.getHeapStatistics?.().heap_size_limit ?? null;
    if (configuredOldSpaceLimit != null) limit = Math.min(limit ?? Infinity, configuredOldSpaceLimit);
  } else {
    const memory = globalThis.performance?.memory;
    if (Number.isFinite(memory?.jsHeapSizeLimit)) limit = memory.jsHeapSizeLimit;
  }
  return Number.isFinite(limit) && limit > 0 ? limit : Infinity;
}

function configuredOldSpaceBytes() {
  if (!isNode) return null;
  const argumentsText = [
    ...(process.execArgv ?? []),
    ...(String(process.env?.NODE_OPTIONS ?? '').match(/(?:[^\s"']+|"[^"]*"|'[^']*')+/g) ?? []),
  ];
  for (let index = 0; index < argumentsText.length; index++) {
    const argument = argumentsText[index];
    const match = /^--max[-_]old[-_]space[-_]size(?:=(\d+))?$/.exec(argument);
    if (!match) continue;
    const megabytes = match[1] ?? argumentsText[index + 1];
    if (/^\d+$/.test(megabytes ?? '')) return Number(megabytes) * 1024 * 1024;
  }
  return null;
}
