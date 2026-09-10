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

%  The context is named in exactly one place -- error__must_be_throw/1 -- so no
%  raise site hands one over (issue #98). It is a throw helper rather than a
%  call_with_error_context/2 wrapper because wrapping a Prolog goal in catch/3
%  costs a child Solver on every call, and must_be/2 succeeds almost always.
must_be(Type, Term) :-
    ( var(Type) -> error__must_be_throw(instantiation_error)
    ; error__must_be(Type, Term)
    ).

error__must_be_throw(Formal) :-
    throw(error(Formal, [predicate-must_be/2])).

error__must_be(integer, Term) :- !,
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; integer(Term) -> true
    ; error__must_be_throw(type_error(integer, Term))
    ).
error__must_be(atom, Term) :- !,
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; atom(Term) -> true
    ; error__must_be_throw(type_error(atom, Term))
    ).
error__must_be(number, Term) :- !,
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; number(Term) -> true
    ; error__must_be_throw(type_error(number, Term))
    ).
error__must_be(var, Term) :- !,
    ( var(Term) -> true
    ; throw(error(uninstantiation_error(Term), []))
    ).
error__must_be(ground, Term) :- !,
    ( ground(Term) -> true ; error__must_be_throw(instantiation_error) ).
error__must_be(acyclic, Term) :- !,
    ( acyclic_term(Term) -> true ; type_error(acyclic_term, Term) ).
error__must_be(list, Term) :- !,
    error__list(Term, Term, must_be/2, complete).
error__must_be(list(Type), Term) :- !,
    error__require_type(Type, must_be/2),
    error__list(Term, Term, must_be/2, complete),
    error__proper_list_of(Term, Type).
error__must_be(character, Term) :- !,
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; atom(Term), atom_length(Term, 1) -> true
    ; error__must_be_throw(type_error(character, Term))
    ).
error__must_be(chars, Term) :- !,
    error__list(Term, Term, must_be/2, partial),
    error__partial_list_of(Term, character, must_be/2),
    error__list(Term, Term, must_be/2, complete),
    error__proper_list_of(Term, character).
error__must_be(pair, Term) :- !,
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; Term = _-_ -> true
    ; error__must_be_throw(type_error(pair, Term))
    ).
error__must_be(not_less_than_zero, Term) :- !,
    must_be(integer, Term),
    ( Term >= 0 -> true ; domain_error(not_less_than_zero, Term) ).
error__must_be(Type, _) :-
    error__must_be_throw(type_error(type, Type)).

% Check the type descriptor before accepting a variable or an empty list.
% The variable guard also prevents validation from instantiating a descriptor.
error__require_type(Type, Predicate) :- var(Type), !,
    throw(error(instantiation_error, [predicate-Predicate])).
error__require_type(list(Type), Predicate) :- !,
    error__require_type(Type, Predicate).
error__require_type(Type, Predicate) :-
    ( error__known_type(Type) -> true
    ; throw(error(type_error(type, Type), [predicate-Predicate])) ).

error__known_type(integer).
error__known_type(atom).
error__known_type(number).
error__known_type(var).
error__known_type(ground).
error__known_type(acyclic).
error__known_type(list).
error__known_type(character).
error__known_type(chars).
error__known_type(pair).
error__known_type(not_less_than_zero).

% A list ends in []; a partial list ends in a variable (including a variable
% alone). Inspect before matching so validation never completes a partial list.
% Keep the original term as the culprit when a tail cannot become a list.
error__list(Term, _, Predicate, Mode) :- var(Term), !,
    ( Mode == partial -> true
    ; throw(error(instantiation_error, [predicate-Predicate])) ).
error__list([], _, _, _) :- !.
error__list([_|Tail], Original, Predicate, Mode) :- !,
    error__list(Tail, Original, Predicate, Mode).
error__list(_, Original, Predicate, _) :-
    throw(error(type_error(list, Original), [predicate-Predicate])).

error__proper_list_of([], _) :- !.
error__proper_list_of([Head|Tail], Type) :- !,
    must_be(Type, Head),
    error__proper_list_of(Tail, Type).
error__proper_list_of(Term, _) :-
    ( var(Term) -> error__must_be_throw(instantiation_error)
    ; type_error(list, Term)
    ).

can_be(Type, Term) :-
    error__require_type(Type, can_be/2),
    ( var(Term) -> true
    ; error__can_be(Type, Term)
    ).

error__can_be_throw(Formal) :-
    throw(error(Formal, [predicate-can_be/2])).

error__can_be(integer, Term) :- !,
    ( integer(Term) -> true ; error__can_be_throw(type_error(integer, Term)) ).
error__can_be(atom, Term) :- !,
    ( atom(Term) -> true ; error__can_be_throw(type_error(atom, Term)) ).
error__can_be(number, Term) :- !,
    ( number(Term) -> true ; error__can_be_throw(type_error(number, Term)) ).
error__can_be(list, Term) :- !, error__list(Term, Term, can_be/2, partial).
error__can_be(list(Type), Term) :- !,
    error__list(Term, Term, can_be/2, partial),
    error__partial_list_of(Term, Type, can_be/2).
error__can_be(character, Term) :- !,
    ( atom(Term), atom_length(Term, 1) -> true
    ; error__can_be_throw(type_error(character, Term)) ).
error__can_be(chars, Term) :- !,
    error__list(Term, Term, can_be/2, partial),
    error__partial_list_of(Term, character, can_be/2).
error__can_be(not_less_than_zero, Term) :- !,
    ( integer(Term) ->
        ( Term >= 0 -> true ; error__can_be_throw(domain_error(not_less_than_zero, Term)) )
    ; error__can_be_throw(type_error(integer, Term))
    ).
error__can_be(Type, Term) :-
    catch(error__must_be(Type, Term), error(Formal, _), error__can_be_throw(Formal)).

error__partial_list_of(Term, _, _) :- var(Term), !.
error__partial_list_of([], _, _) :- !.
error__partial_list_of([Head|Tail], Type, Predicate) :-
    ( var(Head) -> true
    ; Predicate == must_be/2 -> must_be(Type, Head)
    ; can_be(Type, Head)
    ),
    error__partial_list_of(Tail, Type, Predicate).

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
    error__require_pair(Pair),
    catch(Goal,
          error(Error, Context),
          throw(error(Error, [Pair|Context]))).

%  The element must be a pair (issue #99). The test is inlined rather than
%  delegated to must_be(pair, _) so that the wrapper stays independent of the
%  rest of this module. The reported context matches what must_be(pair, _)
%  produces.
%  Written as indexed clauses rather than an if-then-else: this runs on every
%  call_with_error_context/2 call, and an if-then-else costs several times what
%  first-argument clause selection does.
error__require_pair(Pair) :- var(Pair), !,
    throw(error(instantiation_error, [predicate-must_be/2])).
error__require_pair(_-_) :- !.
error__require_pair(Pair) :-
    throw(error(type_error(pair, Pair), [predicate-must_be/2])).
