% Prolog result format 4
query(1, syndrome(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = packet1, 'X1' = 5]).
query(2, errorBit(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = packet1, 'X1' = 5]).
query(3, correctedCodeword(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = packet1, 'X1' = [1, 0, 1, 1, 0, 1, 0]]).
query(4, decodedPayload(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = packet1, 'X1' = [1, 0, 1, 0]]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = packet1, 'X1' = single_bit_corrected]).
query(6, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = packet1, 'X1' = "Hamming syndrome identifies the flipped bit position"]).
