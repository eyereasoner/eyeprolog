// A small ordered worker pool for the suites that do the same work once per
// file: run every example, prove every example, check every packaged proof.
//
// Results are reported in task order however the workers finish, so a parallel
// suite numbers its tests exactly as the sequential one did and a failure still
// stops the run at the same test. Each suite compares inside its worker, so
// only a name, an elapsed time, an optional failure, and a small plain-data
// value cross the thread boundary.
import os from 'node:os';
import { Worker } from 'node:worker_threads';

export async function runTasksInParallel({
  names,
  workerUrl,
  workerData,
  message = {},
  maxWorkers,
  runLocally,
  onResult,
}) {
  if (names.length === 0) return;
  const parallelism = os.availableParallelism?.() ?? os.cpus().length;
  const workerCount = Math.min(names.length, Math.max(1, Math.min(maxWorkers, parallelism - 1)));
  if (workerCount === 1) {
    for (const name of names) {
      const startedAt = performance.now();
      try {
        const value = runLocally(name) ?? null;
        onResult(name, { ms: Math.round(performance.now() - startedAt), value });
      } catch (error) {
        onResult(name, { ms: Math.round(performance.now() - startedAt), error });
      }
    }
    return;
  }

  const completedResults = new Map();
  let nextTask = 0;
  let nextReport = 0;
  let completed = 0;
  let settled = false;

  await new Promise((resolve, reject) => {
    const workers = Array.from({ length: workerCount }, () => new Worker(workerUrl, { workerData }));

    const stopWorkers = () => Promise.all(workers.map((worker) => worker.terminate()));

    const fail = (error) => {
      if (settled) return;
      settled = true;
      stopWorkers().finally(() => reject(error));
    };

    const finish = () => {
      if (settled || completed !== names.length || nextReport !== names.length) return;
      settled = true;
      stopWorkers().then(() => resolve(), reject);
    };

    const reportReady = () => {
      try {
        while (completedResults.has(nextReport)) {
          const result = completedResults.get(nextReport);
          completedResults.delete(nextReport);
          onResult(names[nextReport], result);
          nextReport++;
        }
      } catch (error) {
        fail(error);
      }
    };

    const assign = (worker) => {
      if (nextTask >= names.length || settled) return;
      worker.postMessage({ ...message, id: nextTask, name: names[nextTask++] });
    };

    for (const worker of workers) {
      worker.on('message', ({ id, ms, error, value }) => {
        if (settled) return;
        completedResults.set(id, {
          ms,
          value: value ?? null,
          error: error == null ? null : Object.assign(new Error(error.message), { stack: error.stack }),
        });
        completed++;
        reportReady();
        assign(worker);
        finish();
      });
      worker.on('error', fail);
      assign(worker);
    }
  });
}

// The worker side of the same protocol. `runTask` receives the posted message
// and may return a plain-data value for the pool to hand back with the result.
export function serveTasks(parentPort, runTask) {
  parentPort.on('message', (task) => {
    const startedAt = performance.now();
    try {
      const value = runTask(task) ?? null;
      parentPort.postMessage({ id: task.id, ms: Math.round(performance.now() - startedAt), error: null, value });
    } catch (error) {
      parentPort.postMessage({
        id: task.id,
        ms: Math.round(performance.now() - startedAt),
        error: { message: error?.message ?? String(error), stack: error?.stack ?? String(error) },
      });
    }
  });
}
