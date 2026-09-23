% Scryer-style attributed variables on EyeProlog's annotated-variable runtime.
%
% The attribute declaration is intentionally the same shape used by
% library(atts) clients such as Scryer's CLP(Z). verify_attributes/3 runs before
% an attributed variable is bound; goals it returns run after the binding.

:- use_module(library(atts)).
:- attribute required/1.

%% ?- accepts_required_value(ok).
%% ?- alias_preserves_attribute(ok).

attach_required(Variable, Value) :-
    put_atts(Variable, required(Value)).

verify_attributes(Variable, Other, Goals) :-
    ( get_atts(Variable, required(Value)) ->
        ( var(Other) ->
            put_atts(Other, required(Value)),
            Goals = []
        ; Goals = [required_value(Other, Value)] )
    ; Goals = [] ).

required_value(Value, Value).

accepts_required_value(ok) :-
    attach_required(X, 7),
    X = 7.

alias_preserves_attribute(ok) :-
    attach_required(X, ready),
    X = Y,
    get_atts(Y, required(ready)),
    Y = ready.

% The REPL uses the conventional attribute_goals//1 hook to project remaining
% attributes as residual goals.
attribute_goals(X) -->
    { get_atts(X, required(Value)) },
    [required(X, Value)].
