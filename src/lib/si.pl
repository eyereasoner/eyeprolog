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
si__list(Term) :-
    var(Term), !, throw(error(instantiation_error, [predicate-list_si/1])).
si__list([]).
si__list([_|Tail]) :- !, si__list(Tail).

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
    si__require_order(Order),
    si__compare(Order, [A-B]).

si__require_order(Order) :- var(Order), !.
si__require_order(Order) :-
    ( atom(Order) ->
        ( (Order == (<) ; Order == (=) ; Order == (>)) -> true
        ; throw(error(domain_error(order, Order), [predicate-compare_si/3]))
        )
    ; throw(error(type_error(atom, Order), [predicate-compare_si/3]))
    ).

% Keep pending argument pairs in a work list. Recursing inside an if-then-else
% condition retains a child Solver per list cell; testing whole-tail identity
% at each step also repeatedly scans the same suffix (issue #105).
si__compare(=, []).
si__compare(Order, [A-B|Pairs]) :-
    si__compare_pair(A, B, Comparison, Pairs, Next),
    si__compare_next(Comparison, Order, Next).

si__compare_next(=, Order, Pairs) :- si__compare(Order, Pairs).
si__compare_next(<, <, _).
si__compare_next(>, >, _).

si__compare_pair(A, B, =, Pairs, Pairs) :-
    ( var(A) ; var(B) ), !,
    ( A == B -> true
    ; throw(error(instantiation_error, [predicate-compare_si/3])) ).
si__compare_pair([A|As], [B|Bs], =, Pairs, [A-B,As-Bs|Pairs]) :- !.
si__compare_pair(A, B, Comparison, Pairs, Next) :-
    compound(A), compound(B), !,
    functor(A, NameA, ArityA),
    functor(B, NameB, ArityB),
    (  ArityA =\= ArityB -> compare(Comparison, ArityA, ArityB), Next = Pairs
    ;  NameA \== NameB -> compare(Comparison, NameA, NameB), Next = Pairs
    ;  A =.. [_|ArgsA],
       B =.. [_|ArgsB],
       Comparison = (=),
       si__prepend_pairs(ArgsA, ArgsB, Next, Pairs)
    ).
si__compare_pair(A, _, >, Pairs, Pairs) :- compound(A), !.
si__compare_pair(_, B, <, Pairs, Pairs) :- compound(B), !.
si__compare_pair(A, B, Comparison, Pairs, Pairs) :- compare(Comparison, A, B).

si__prepend_pairs([], [], Pairs, Pairs).
si__prepend_pairs([A|As], [B|Bs], [A-B|Pairs], Tail) :-
    si__prepend_pairs(As, Bs, Pairs, Tail).
