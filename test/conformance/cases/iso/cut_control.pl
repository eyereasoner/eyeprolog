choice(a).
choice(b).

committed(first) :-
    !.
committed(second).

left_choice(Value) :-
    choice(Value),
    !.

right_choice(Left, Right) :-
    choice(Left),
    !,
    choice(Right).

cut_failure :-
    choice(Value),
    !,
    fail.
cut_failure.

disjunction_cut(Value) :-
    (=(Value, a); =(Value, b)),
    !.

call_is_local(from_call, Value) :-
    call((choice(Value), !)),
    fail.
call_is_local(fallback, ok).

if_then_cut(Value) :-
    (true -> (!, choice(Value)); fail).
if_then_cut(fallback).

callee_cut_then_fail :-
    !,
    fail.

callee_cut_disjunction :-
    (callee_cut_then_fail; true).

between_disjunction :-
    (between(1, 1, _), false; true).

%% ?- committed_answer(X0).

committed_answer(Value) :-
    committed(Value).

%% ?- left_answer(X0).

left_answer(Value) :-
    left_choice(Value).

%% ?- right_answer(X0, X1).

right_answer(Left, Right) :-
    right_choice(Left, Right).

%% ?- cut_failure_answer.

cut_failure_answer :-
    \+(cut_failure).

%% ?- disjunction_answer(X0).

disjunction_answer(Value) :-
    disjunction_cut(Value).

%% ?- call_local_answer(X0, X1).

call_local_answer(Kind, Value) :-
    call_is_local(Kind, Value).

%% ?- if_then_answer(X0).

if_then_answer(Value) :-
    if_then_cut(Value).

%% ?- callee_cut_disjunction_answer.

callee_cut_disjunction_answer :-
    callee_cut_disjunction.

%% ?- between_disjunction_answer.

between_disjunction_answer :-
    between_disjunction.
