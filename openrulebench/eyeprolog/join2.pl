% OpenRuleBench -> EyeProlog portable benchmark
% Generated deterministically by tools/generate.mjs.
% See ../README.md for provenance and fidelity notes.

ra(A,B,C,D,E) :- p(A), p(B), p(C), p(D), p(E).
rb(A,B,C,D,E) :- p(A), p(B), p(C), p(D), p(E).
r(A,B,C,D,E) :- ra(A,B,C,D,E), rb(A,B,C,D,E).
q1(A) :- r(A,_,_,_,_).
q2(B) :- r(_,B,_,_,_).
q3(C) :- r(_,_,C,_,_).
q4(D) :- r(_,_,_,D,_).
q5(E) :- r(_,_,_,_,E).
benchmark(Count) :- findall(A, q1(A), Answers), length(Answers, Count).
%% ?- benchmark(Count).

p(a0).
p(a1).
p(a2).
p(a3).
p(a4).
p(a5).
p(a6).
p(a7).
p(a8).
p(a9).
p(a10).
p(a11).
p(a12).
p(a13).
p(a14).
p(a15).
p(a16).
p(a17).
p(a18).
