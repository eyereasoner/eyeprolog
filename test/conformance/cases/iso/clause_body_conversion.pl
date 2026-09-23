% ISO 7.6.2 a: when a term is converted to the body of a clause, a variable
% goal becomes call/1. ISO 7.6.2 b applies the conversion recursively through
% (,)/2, (;)/2 and (->)/2. ISO 7.5.1 prepares the read-terms of a Prolog text
% into database clauses by that same conversion, so a clause loaded from a
% Prolog text and the identical clause added by assertz/1 must agree.

:- dynamic(from_text/1).
from_text(Goal) :- Goal.

:- dynamic(nested/3).
nested(A, B, C) :- (A ; B), (C -> true ; true).

:- dynamic(cut_scope/1).
cut_scope(Goal) :- Goal.
cut_scope(_) :- true.

%% ?- text_body(X0).

text_body(Body) :-
    clause(from_text(true), Body).

%% ?- nested_body(X0).

nested_body(Body) :-
    clause(nested(a, b, c), Body).

%% ?- assert_agrees_with_text(X0).

% The same clause added at run time must convert to the same body term.
assert_agrees_with_text(Agree) :-
    assertz((asserted(Goal) :- Goal)),
    clause(from_text(true), TextBody),
    clause(asserted(true), AssertedBody),
    ( TextBody == AssertedBody -> Agree = agree ; Agree = differ ).

%% ?- cut_is_local(X0).

% 7.8.3: a cut in the argument of call/1 is local to that call, so it must not
% prune the remaining clauses of cut_scope/1.
cut_is_local(Solutions) :-
    findall(taken, cut_scope(!), Solutions).
