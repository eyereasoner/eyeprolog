% Generated state variables must not capture similarly named source variables.

capture_states(S0, S, Input, Output) -->
    [S0, S],
    {Input = source_input, Output = source_output}.
anonymous_pair --> [_, _].

%% ?- phrase(capture_states(A, B, Input, Output), [left, right]).
%% ?- phrase(anonymous_pair, [one, two]).
