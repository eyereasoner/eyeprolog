'\a'
!
[:-,-]
f(*)
f(;,'|',';;')
a*(b+c)
a:-b,c
'.'(a,[])
'\0\'
''
a
ab
'a b'
'\33\'
% Prolog result format 4
query(1, wg17_numeric_escape, []).
result(1, complete, 1).
answer(1, []).
query(2, wg17_hex_escape, []).
result(2, complete, 1).
answer(2, []).
query(3, wg17_operator_arguments, []).
result(3, complete, 1).
answer(3, []).
query(4, wg17_operator_precedence, []).
result(4, complete, 1).
answer(4, []).
query(5, wg17_spaced_prefix_operator(_0), ['T' = _0]).
result(5, complete, 1).
answer(5, ['T' = (a, b)]).
query(6, wg17_canonical_list, []).
result(6, complete, 1).
answer(6, []).
query(7, wg17_zero_character_escape, []).
result(7, complete, 1).
answer(7, []).
query(8, wg17_continuation_escapes, []).
result(8, complete, 1).
answer(8, []).
query(9, wg17_non_symbolic_control_write, []).
result(9, complete, 1).
answer(9, []).
