% High-risk ISO syntax/write regressions, independently derived from
% ISO/IEC 13211-1 clauses 6.3, 6.4 and 7.10 and cross-checked against the
% public WG17 conformity-testing syntax cases (#1, #7-10, #14-15, #18, #28-31, #33-34, #299, #301, #315-316).

%% ?- wg17_numeric_escape.
wg17_numeric_escape :-
    writeq('\7\'), nl.

%% ?- wg17_hex_escape.
wg17_hex_escape :-
    writeq('\x21\'), nl.

%% ?- wg17_operator_arguments.
wg17_operator_arguments :-
    writeq([:-,-]), nl,
    writeq(f(*)), nl,
    writeq(f(;,'|',';;')), nl.

%% ?- wg17_operator_precedence.
wg17_operator_precedence :-
    writeq(a*(b+c)), nl,
    writeq((a :- b,c)), nl.

%% ?- wg17_spaced_prefix_operator(T).
wg17_spaced_prefix_operator(T) :-
    (\+ (a,b)) = \+(T).

%% ?- wg17_canonical_list.
wg17_canonical_list :-
    write_canonical([a]), nl.

%% ?- wg17_zero_character_escape.
wg17_zero_character_escape :-
    writeq('\0\'), nl.

%% ?- wg17_continuation_escapes.
wg17_continuation_escapes :-
    writeq('\
'), nl,
    writeq('\
a'), nl,
    writeq('a\
b'), nl,
    writeq('a\
 b'), nl.

%% ?- wg17_non_symbolic_control_write.
wg17_non_symbolic_control_write :-
    writeq('\033\'), nl.
