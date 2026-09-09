/** Sufficient-instantiation tests compatible with Scryer library(si). */

:- module(si, [
    atom_si/1,
    integer_si/1,
    atomic_si/1,
    list_si/1,
    character_si/1,
    term_si/1,
    chars_si/1,
    compare_si/3,
    dif_si/2,
    not_si/1,
    when_si/2
]).

:- meta_predicate(not_si(0)).
:- meta_predicate(when_si(+, 0)).

atom_si(A) :- ( var(A) -> throw(error(instantiation_error, [predicate-atom_si/1])) ; atom(A) ).
integer_si(I) :- ( var(I) -> throw(error(instantiation_error, [predicate-integer_si/1])) ; integer(I) ).
atomic_si(A) :- ( var(A) -> throw(error(instantiation_error, [predicate-atomic_si/1])) ; atomic(A) ).

list_si(List) :- si__list(List).
si__list([]).
si__list([_|Tail]) :- !, si__list(Tail).
si__list(Term) :-
    ( var(Term) -> throw(error(instantiation_error, [predicate-list_si/1])) ; fail ).

character_si(C) :-
    ( var(C) -> throw(error(instantiation_error, [predicate-character_si/1]))
    ; atom(C), atom_length(C, 1)
    ).

term_si(Term) :-
    ( ground(Term) -> acyclic_term(Term)
    ; throw(error(instantiation_error, [predicate-term_si/1]))
    ).

chars_si(Chars) :-
    list_si(Chars),
    si__chars(Chars).
si__chars([]).
si__chars([C|Cs]) :- character_si(C), si__chars(Cs).

dif_si(X, Y) :-
    X \== Y,
    ( X \= Y -> true ; throw(error(instantiation_error, [predicate-dif_si/2])) ).

not_si(Goal) :- term_si(Goal), \+ Goal.

when_si(Condition, Goal) :-
    ( si__condition(Condition) ->
        ( call(Condition) -> call(Goal)
        ; throw(error(instantiation_error, [predicate-when_si/2])) )
    ; throw(error(domain_error(when_condition_si, Condition), when_si/2))
    ).

si__condition(Condition) :- var(Condition), !, throw(error(instantiation_error, [predicate-when_si/2])).
si__condition(ground(_)).
si__condition(nonvar(_)).
si__condition((A,B)) :- si__condition(A), si__condition(B).
si__condition((A;B)) :- si__condition(A), si__condition(B).

%  compare_si(Order, A, B) holds when compare(Order, A, B) holds for *every*
%  instance of A and B, and raises an instantiation_error otherwise. The point
%  is to raise it as rarely as possible: an unbound variable only matters when
%  it is what decides the ordering. So f(X) @< g(Y) is decided by the functor
%  names, f(X,a) @< f(X,b) by the second arguments, and X == X gives (=), while
%  f(a) vs f(Y) and X vs 1 are genuinely undecided.
compare_si(Order, A, B) :-
    (  A == B
    -> Order = (=)
    ;  si__order_decided(A, B)
    -> compare(Order, A, B)
    ;  throw(error(instantiation_error, [predicate-compare_si/3]))
    ).

%  Both arguments are known to be non-identical here.
si__order_decided(A, B) :- ( var(A) ; var(B) ), !, fail.
si__order_decided(A, B) :-
    compound(A), compound(B), !,
    functor(A, NameA, ArityA),
    functor(B, NameB, ArityB),
    (  ArityA =\= ArityB -> true
    ;  NameA \== NameB -> true
    ;  A =.. [_|ArgsA],
       B =.. [_|ArgsB],
       si__args_decided(ArgsA, ArgsB)
    ).
%  Otherwise both are non-variables and at least one is atomic, so either the
%  type order or the values themselves settle it and no instantiation can
%  change the outcome.
si__order_decided(_, _).

si__args_decided([A|As], [B|Bs]) :-
    (  A == B
    -> si__args_decided(As, Bs)
    ;  si__order_decided(A, B)
    ).
