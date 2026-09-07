% From The Art of EyeProlog, Chapter 39 — Library relations by programming role.
:- use_module(library(dates)).
:- use_module(library(between), [between/3]).
:- use_module(library(random)).
:- use_module(library(lists)).

answer(square, S) :- (S is 12 * 12).
answer(day_count, N) :- between(3, 5, N).
answer(age, D) :- difference('2026-07-28', '2020-05-20', D).
answer(random_pair, [A,B]) :- random(42, A, S), random(S, B, _).
