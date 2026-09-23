% Classic Prolog "naive reverse" benchmark (Quintus, 1984), adapted as a
% deterministic EyeProlog example.  The traditional workload reverses a
% 30-element list with nrev/2 and concatenate/3.  It takes 496 Prolog
% procedure calls per reversal in the original LIPS accounting.
%
% `npm run benchmark:lips` uses the classic dobench/dodummy control subtraction
% with Node's process CPU clock, avoiding a dependency on a Prolog-specific
% statistics/2 clock while preserving the benchmark methodology. See README.md.
%
% Source/history:
% https://gerrit.googlesource.com/prolog-cafe/+/73b5ce4f5fbef086a22de3292a53e1ffe2947fab/examples/benchmarks/src/bench.pl

%% ?- bench_result(X0).

nrev([], []).
nrev([X|Rest], Ans) :-
    nrev(Rest, L),
    concatenate(L, [X], Ans).

concatenate([], L, L).
concatenate([X|L1], L2, [X|L3]) :-
    concatenate(L1, L2, L3).

data([1,2,3,4,5,6,7,8,9,10,
      11,12,13,14,15,16,17,18,19,20,
      21,22,23,24,25,26,27,28,29,30]).

bench_result(Reversed) :-
    data(List),
    nrev(List, Reversed).

% Supporting predicates from the classic benchmark harness.  The JavaScript
% benchmark driver times dodummy/1 and dobench/1 separately and subtracts the
% dummy time, matching the Quintus methodology without requiring a particular
% Prolog statistics/2 clock implementation.

dobench(Count) :-
    data(List),
    bench_repeat(Count),
    nrev(List, _),
    fail.
dobench(_).

dodummy(Count) :-
    data(List),
    bench_repeat(Count),
    dummy(List, _),
    fail.
dodummy(_).

dummy(_, _).

bench_repeat(_N).
bench_repeat(N) :-
    N > 1,
    N1 is N - 1,
    bench_repeat(N1).
