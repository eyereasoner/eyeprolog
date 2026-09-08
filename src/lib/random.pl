/** Reproducible pseudo-random values.

    random/3 is EyeProlog's explicit-state interface.  maybe/0, maybe/1, maybe/2,
    random/1, random_integer/3, and set_random/1 are the mutable-seed library
    interface used for compatibility. random/1 uses EyeProlog's private native
    state step for hot-loop performance; random/3 remains the portable explicit-
    state Park-Miller generator, and both retain the same sequence.
*/

:- module(random, [maybe/0, maybe/1, maybe/2, random/1, random/3, random_integer/3, set_random/1]).

:- use_module(library(iso_ext), [bb_get/2, bb_put/2]).
:- use_module(library(error), [call_with_error_context/2, instantiation_error/0, type_error/2]).

maybe :-
    random_integer(0, 2, 0).

maybe(Probability) :-
    random(Value),
    Value < Probability.

maybe(K, N) :-
    Probability is K / N,
    random(Value),
    Value < Probability.


random(Value) :-
    eyeprolog__random_value(Value).

%  Context declared once per predicate instead of at each raise site, so the
%  raise sites throw with [] and contexts stay proper composable lists.
random_integer(Lower, Upper, R) :-
    call_with_error_context(random__check_integer_range(Lower, Upper), random_integer/3),
    Lower < Upper,
    random__current_seed(Seed0),
    random(Seed0, _, Seed),
    bb_put('$random_seed', Seed),
    R is Lower + Seed mod (Upper - Lower).

set_random(Seed) :-
    call_with_error_context(random__set_seed(Seed), set_random/1).

random__check_integer_range(Lower, Upper) :-
    ( var(Lower) -> instantiation_error
    ; var(Upper) -> instantiation_error
    ; integer(Lower) -> true
    ; type_error(integer, Lower)
    ),
    ( integer(Upper) -> true
    ; type_error(integer, Upper)
    ).

random__set_seed(Seed) :-
    ( var(Seed) -> instantiation_error
    ; Seed = seed(S) ->
        ( var(S) -> instantiation_error
        ; integer(S) ->
            random__random_normalize_seed(S, Normalized),
            bb_put('$random_seed', Normalized)
        ; type_error(integer, S)
        )
    ; type_error(random_state, Seed)
    ).

random__current_seed(Seed) :- bb_get('$random_seed', Seed), !.
random__current_seed(1).

% A Park-Miller generator with explicit state. Threading Seed into the next
% call makes a sequence reproducible without mutable runtime state. Schrage's
% method keeps every intermediate integer within the exact 32-bit range.
random(Seed0, Value, Seed) :-
    integer(Seed0),
    random__random_normalize_seed(Seed0, Normalized),
    High is Normalized // 44488,
    Low is Normalized mod 44488,
    Candidate is 48271 * Low - 3399 * High,
    random__random_wrap(Candidate, Seed),
    Value is (Seed - 1) / 2147483646.

random__random_normalize_seed(Seed, 1) :-
    0 is Seed mod 2147483647,
    !.
random__random_normalize_seed(Seed, Normalized) :-
    Normalized is Seed mod 2147483647.

random__random_wrap(Candidate, Candidate) :- Candidate > 0, !.
random__random_wrap(Candidate, Seed) :- Seed is Candidate + 2147483647.
