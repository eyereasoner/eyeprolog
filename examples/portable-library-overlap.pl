% Representative source shared with the Scryer and Trealla library layouts.

:- use_module(library(charsio), [char_type/2]).
:- use_module(library(clpb), [sat/1, labeling/1]).
:- use_module(library(gensym), [gensym/2, reset_gensym/1]).
:- use_module(library(lists), [transpose/2]).
:- use_module(library(ordsets), [ord_union/3]).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(library(tabling)).
:- use_module(library(ugraphs), [vertices_edges_to_ugraph/3, reachable/3]).
:- use_module(library(when), [when/2]).

:- table path/2.

edge(a, b).
edge(b, c).

path(X, Y) :- path(X, Z), edge(Z, Y).
path(X, Y) :- edge(X, Y).

%% ?- overlap_example(Result).

overlap_example(overlap(
    booleans([X,Y]),
    union(Union),
    reachable(Reachable),
    filtered(Filtered),
    awakened(Awakened),
    generated(Generated),
    uppercase(Uppercase),
    transposed(Transposed),
    tabled_paths(Paths)
)) :-
    sat(X * ~Y),
    labeling([X,Y]),
    ord_union([a,c], [b,c], Union),
    vertices_edges_to_ugraph([a,b,c], [a-b,b-c], Graph),
    reachable(a, Graph, Reachable),
    tfilter(=(a), [a,b,a], Filtered),
    when(nonvar(Wake), Awakened = yes),
    Wake = now,
    reset_gensym(shared),
    gensym(shared, Generated),
    char_type(a, upper(Uppercase)),
    transpose([[1,2,3],[4,5,6]], Transposed),
    findall(Node, path(a, Node), Paths).
