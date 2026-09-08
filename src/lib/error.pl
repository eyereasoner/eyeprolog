/** Small Scryer-compatible error/type layer used by reusable libraries. */

:- module(error, [
    must_be/2,
    can_be/2,
    instantiation_error/0,
    instantiation_error/1,
    domain_error/2,
    domain_error/3,
    type_error/2,
    type_error/3,
    representation_error/1,
    resource_error/1,
    resource_error/2,
    call_with_error_context/2
]).

:- meta_predicate(call_with_error_context(0, +)).

%  The context is supplied once here rather than handed over manually at every
%  raise site: the raise sites throw with [] and this wrapper prepends its
%  element, so contexts stay proper lists and compose with any enclosing
%  call_with_error_context/2 (issue #98).
must_be(Type, Term) :-
    call_with_error_context(
        ( var(Type) -> instantiation_error
        ; error__must_be(Type, Term)
        ),
        must_be/2).

error__must_be(integer, Term) :- !,
    ( var(Term) -> instantiation_error
    ; integer(Term) -> true
    ; type_error(integer, Term)
    ).
error__must_be(atom, Term) :- !,
    ( var(Term) -> instantiation_error
    ; atom(Term) -> true
    ; type_error(atom, Term)
    ).
error__must_be(number, Term) :- !,
    ( var(Term) -> instantiation_error
    ; number(Term) -> true
    ; type_error(number, Term)
    ).
error__must_be(var, Term) :- !,
    ( var(Term) -> true
    ; throw(error(uninstantiation_error(Term), []))
    ).
error__must_be(ground, Term) :- !,
    ( ground(Term) -> true ; instantiation_error ).
error__must_be(acyclic, Term) :- !,
    ( acyclic_term(Term) -> true ; type_error(acyclic_term, Term) ).
error__must_be(list, Term) :- !,
    error__proper_list(Term).
error__must_be(list(Type), Term) :- !,
    error__proper_list_of(Term, Type).
error__must_be(pair, Term) :- !,
    ( var(Term) -> instantiation_error
    ; Term = _-_ -> true
    ; type_error(pair, Term)
    ).
error__must_be(not_less_than_zero, Term) :- !,
    must_be(integer, Term),
    ( Term >= 0 -> true ; domain_error(not_less_than_zero, Term) ).
error__must_be(Type, Term) :-
    ( var(Term) -> instantiation_error
    ; type_error(Type, Term)
    ).

error__proper_list([]) :- !.
error__proper_list([_|Tail]) :- !, error__proper_list(Tail).
error__proper_list(Term) :-
    ( var(Term) -> instantiation_error
    ; type_error(list, Term)
    ).

error__proper_list_of([], _) :- !.
error__proper_list_of([Head|Tail], Type) :- !,
    must_be(Type, Head),
    error__proper_list_of(Tail, Type).
error__proper_list_of(Term, _) :-
    ( var(Term) -> instantiation_error
    ; type_error(list, Term)
    ).

can_be(Type, Term) :-
    ( var(Type) -> instantiation_error(can_be/2)
    ; var(Term) -> true
    ; error__can_be(Type, Term)
    ).

error__can_be(integer, Term) :- !,
    ( integer(Term) -> true ; type_error(integer, Term, can_be/2) ).
error__can_be(atom, Term) :- !,
    ( atom(Term) -> true ; type_error(atom, Term, can_be/2) ).
error__can_be(number, Term) :- !,
    ( number(Term) -> true ; type_error(number, Term, can_be/2) ).
error__can_be(list, Term) :- !, error__partial_list(Term).
error__can_be(list(Type), Term) :- !, error__partial_list_of(Term, Type).
error__can_be(not_less_than_zero, Term) :- !,
    ( integer(Term) ->
        ( Term >= 0 -> true ; domain_error(not_less_than_zero, Term, can_be/2) )
    ; type_error(integer, Term, can_be/2)
    ).
error__can_be(Type, Term) :- error__must_be(Type, Term).

error__partial_list(Term) :- var(Term), !.
error__partial_list([]) :- !.
error__partial_list([_|Tail]) :- !, error__partial_list(Tail).
error__partial_list(Term) :- type_error(list, Term, can_be/2).

error__partial_list_of(Term, _) :- var(Term), !.
error__partial_list_of([], _) :- !.
error__partial_list_of([Head|Tail], Type) :- !,
    can_be(Type, Head),
    error__partial_list_of(Tail, Type).
error__partial_list_of(Term, _) :- type_error(list, Term, can_be/2).

instantiation_error :- throw(error(instantiation_error, [])).
instantiation_error(Context) :- throw(error(instantiation_error, Context)).
domain_error(Type, Term) :- throw(error(domain_error(Type, Term), [])).
domain_error(Type, Term, Context) :- throw(error(domain_error(Type, Term), Context)).
type_error(Type, Term) :- throw(error(type_error(Type, Term), [])).
type_error(Type, Term, Context) :- throw(error(type_error(Type, Term), Context)).
representation_error(Flag) :- throw(error(representation_error(Flag), [])).
resource_error(Resource) :- throw(error(resource_error(Resource), [])).
resource_error(Resource, Context) :- throw(error(resource_error(Resource), Context)).

%  Context elements are assembled only when an error actually propagates, so
%  the prepend costs nothing on success. The enclosing catch/3 frame is not
%  free, though: see issue #98 for measurements and the primitive design that
%  would remove it.
call_with_error_context(Goal, Pair) :-
    catch(Goal,
          error(Error, Context),
          ( copy_term(Pair, Element),
            throw(error(Error, [Element|Context])) )).
