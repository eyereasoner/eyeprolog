#!/usr/bin/env node
import { Worker } from 'node:worker_threads';
import { run } from '../src/index.js';
import { TestReporter, assertEqual, assertIncludes, isMainModule, runStandalone } from './test-style.mjs';

function serverPort(worker) {
  return new Promise((resolve, reject) => {
    worker.once('message', ({ port }) => resolve(port));
    worker.once('error', reject);
  });
}

export async function runHttpJson(reporter = new TestReporter()) {
  reporter.section('HTTP and JSON libraries');

  reporter.test('library(json) parses nested JSON with whitespace and escapes', () => {
    const source = String.raw`:- use_module(library(json)).
:- use_module(library(dcgs)).
answer(X) :- phrase(json_chars(X), " {\"a\":[1,true,null,\"x\\ny\"]} ").`;
    assertEqual(run(source, { goal: 'answer(X)' }).stdout,
      'answer(pairs([string("a") - list([number(1), boolean(true), null, string("x\\ny")])])).\n',
      'nested JSON parse');
  });

  reporter.test('library(json) generates canonical JSON as its first solution', () => {
    const source = `:- use_module(library(json)).
:- use_module(library(dcgs)).
answer(Cs) :- once(phrase(json_chars(pairs([string("a")-number(2),string("ok")-boolean(true)])), Cs)).`;
    assertEqual(run(source, { goal: 'answer(Cs)' }).stdout,
      'answer("{\\"a\\":2,\\"ok\\":true}").\n', 'JSON generation');
  });

  reporter.test('library(json) combines supplementary Unicode surrogate escapes', () => {
    const source = String.raw`:- use_module(library(json)).
:- use_module(library(dcgs)).
answer(X) :- phrase(json_chars(X), "\"\\uD83D\\uDE00\"").`;
    assertEqual(run(source, { goal: 'answer(X)' }).stdout,
      'answer(string("😀")).\n', 'JSON surrogate-pair parse');
  });

  reporter.test('library(json) generates and validates supplementary Unicode escapes relationally', () => {
    const source = String.raw`:- use_module(library(json)).
:- use_module(library(dcgs)).
answer :- phrase(json_chars(string("😀")), "\"\\uD83D\\uDE00\"").`;
    assertEqual(run(source, { goal: 'answer' }).stdout, 'answer.\n', 'JSON surrogate-pair generation');
  });

  reporter.test('library(json) rejects unpaired UTF-16 surrogates', () => {
    const source = String.raw`:- use_module(library(json)).
:- use_module(library(dcgs)).
answer :- \+ phrase(json_chars(_), "\"\\uD83D\""),
          \+ phrase(json_chars(_), "\"\\uDE00\"").`;
    assertEqual(run(source, { goal: 'answer' }).stdout, 'answer.\n', 'unpaired JSON surrogate rejection');
  });

  reporter.test('http_request/5 parses request lines and lower-cases header names', () => {
    const source = `:- use_module(library(http)).
answer(M,P,V,H) :- http_request(user_input,M,P,V,H).`;
    const result = run(source, {
      goal: 'answer(M,P,V,H)',
      ioOptions: { input: 'get /hello HTTP/1.1\r\nHost: Example.COM\r\nX-Test: yes\r\n\r\n' },
    });
    assertEqual(result.stdout,
      'answer("GET", "/hello", "1.1", ["host":"Example.COM", "x-test":"yes"]).\n',
      'HTTP request parse');
  });

  const worker = new Worker(new URL('./fixtures/http-test-server.mjs', import.meta.url), { type: 'module' });
  const port = await serverPort(worker);
  try {
    reporter.test('http_get/3 follows redirects and exposes Trealla-style response metadata', () => {
      const source = `:- use_module(library(http)).
answer(Data,Code,Headers,Final) :-
  http_get("http://127.0.0.1:${port}/redirect", Data,
           [status_code(Code),headers(Headers),final_url(Final),header("x-test","ok")]).`;
      const output = run(source, { goal: 'answer(Data,Code,Headers,Final)' }).stdout;
      assertIncludes(output, 'method', 'redirect body');
      assertIncludes(output, ', 200, [', 'status code');
      assertIncludes(output, '"x-eyeprolog-test":"yes"', 'response header');
      assertIncludes(output, `"http://127.0.0.1:${port}/final"`, 'final URL');
    });

    reporter.test('http_post/4 sends data and Scryer-style request_headers/1', () => {
      const source = `:- use_module(library(http)).
answer(Data,Code) :-
  http_post("http://127.0.0.1:${port}/post", "hello", Data,
            [status_code(Code),request_headers(['x-test'("yes")])]).`;
      const output = run(source, { goal: 'answer(Data,Code)' }).stdout;
      assertIncludes(output, '\\"method\\":\\"POST\\"', 'POST method');
      assertIncludes(output, '\\"body\\":\\"hello\\"', 'POST body');
      assertIncludes(output, '\\"test\\":\\"yes\\"', 'request header');
      assertIncludes(output, ', 200).', 'POST status');
    });

    reporter.test('http_open/3 returns an ordinary body stream and Scryer-style size/status options', () => {
      const source = `:- use_module(library(http)).
:- use_module(library(charsio)).
answer(Data,Code,Size) :-
  http_open("http://127.0.0.1:${port}/open", S, [status_code(Code),size(Size)]),
  get_n_chars(S,_,Data), close(S).`;
      const output = run(source, { goal: 'answer(Data,Code,Size)' }).stdout;
      assertIncludes(output, '\\"path\\":\\"/open\\"', 'http_open body');
      assertIncludes(output, ', 200, ', 'http_open status and size');
    });

    reporter.test('GET omits an entity Content-Length unless data/1 is explicit', () => {
      const source = `:- use_module(library(http)).
answer(Data) :- http_get("http://127.0.0.1:${port}/headers", Data, []).`;
      const output = run(source, { goal: 'answer(Data)' }).stdout;
      assertIncludes(output, '\\"contentLength\\":null', 'GET content-length omission');
    });

    reporter.test('explicit empty POST data sends Content-Length zero', () => {
      const source = `:- use_module(library(http)).
answer(Data) :- http_post("http://127.0.0.1:${port}/post-empty", "", Data, []).`;
      const output = run(source, { goal: 'answer(Data)' }).stdout;
      assertIncludes(output, '\\"contentLength\\":\\"0\\"', 'empty POST content-length');
    });

    reporter.test('request_headers/1 preserves repeated header values', () => {
      const source = `:- use_module(library(http)).
answer(Data) :-
  http_get("http://127.0.0.1:${port}/headers", Data,
           [request_headers(['x-repeat'("one"),'x-repeat'("two")])]).`;
      const output = run(source, { goal: 'answer(Data)' }).stdout;
      assertIncludes(output, '\\"repeated\\":\\"one, two\\"', 'repeated request headers');
    });

    reporter.test('http_open/3 streams bodies larger than the host RPC buffer', () => {
      const source = `:- use_module(library(http)).
:- use_module(library(charsio)).
answer(Prefix) :-
  http_open("http://127.0.0.1:${port}/large", S, []),
  get_n_chars(S,16,Prefix), close(S).`;
      assertEqual(run(source, { goal: 'answer(Prefix)' }).stdout,
        'answer("xxxxxxxxxxxxxxxx").\n', 'large HTTP response streaming');
    });
  } finally {
    worker.postMessage('close');
    await worker.terminate();
  }

  reporter.sectionTotal('HTTP and JSON libraries');
}

if (isMainModule(import.meta.url)) await runStandalone(runHttpJson);
