% ISO 7.12.1: throw/1 copies the ball before searching for a catcher.
%% ?- user_throw_copy.
%% ?- error_throw_copy.

user_throw_copy :-
    catch(throw(g(X)), g(V), true),
    X = protected,
    V = caught.

error_throw_copy :-
    catch(
        number_chars(_, [1, [], X|2]),
        error(type_error(list, Culprit), _),
        true
    ),
    X = protected,
    Culprit = [1, [], caught|2].
