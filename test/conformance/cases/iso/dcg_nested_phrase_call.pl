% phrase//1 and call//1 compose nested grammar invocations.

inner --> [i].
outer --> phrase(inner), call(inner), [o].

%% ?- phrase(outer, Tokens).
