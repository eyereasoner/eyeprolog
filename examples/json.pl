% JSON parsing and generation with the shared Scryer/Trealla representation.
%
% Objects are pairs([...]), arrays are list([...]), strings are string(Chars),
% numbers are number(N), booleans are boolean(true/false), and null is null.
% Supplementary Unicode JSON escapes are combined from UTF-16 surrogate pairs.

:- use_module(library(json)).
:- use_module(library(dcgs)).

%% ?- json_example(Mode, Value).

json_example(parsed, JSON) :-
    phrase(json_chars(JSON), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}").

json_example(generated, Chars) :-
    once(phrase(json_chars(pairs([
        string("project")-string("EyeProlog"),
        string("ok")-boolean(true)
    ])), Chars)).
