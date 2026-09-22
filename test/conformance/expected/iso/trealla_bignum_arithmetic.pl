% Prolog result format 4
query(1,
      bignum_ops(_0, _1, _2, _3, _4),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4]).
result(1, complete, 1).
answer(1,
       ['X0' = -123456789012345678901234567890,
        'X1' = 42,
        'X2' = 9000000000900000000090,
        'X3' = 122443787781019052100,
        'X4' = 1234567890123456788901234657800000]).
query(2, bignum_float_conversion(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = 1.881676372353658e+78]).
query(3, bignum_mod_rem_agree_for_positive_operands(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = 122443787781019052100, 'X1' = 122443787781019052100]).
query(4, bignum_gcd_commutative(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = 42, 'X1' = 42]).
