% Prolog result format 4
query(1, declared_public(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = moose(bertha)]).
query(2, undeclared_sibling(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = moose / 1]).
query(3, public_is_not_dynamic(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = permission_error(modify, static_procedure, elk / 1)]).
query(4, flag_default(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = private]).
query(5, flag_opens_every_procedure(_0), ['X0' = _0]).
result(5, complete, 1).
answer(5, ['X0' = true]).
query(6, builtins_stay_private(_0), ['X0' = _0]).
result(6, complete, 1).
answer(6, ['X0' = atom / 1]).
