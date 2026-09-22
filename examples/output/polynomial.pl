% Prolog result format 4
query(1, polynomial(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, root(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 8).
answer(2, ['X0' = real_quartic, 'X1' = [1, 0]]).
answer(2, ['X0' = real_quartic, 'X1' = [2, 0]]).
answer(2, ['X0' = real_quartic, 'X1' = [3, 0]]).
answer(2, ['X0' = real_quartic, 'X1' = [4, 0]]).
answer(2, ['X0' = complex_quartic, 'X1' = [0, 1]]).
answer(2, ['X0' = complex_quartic, 'X1' = [1, 1]]).
answer(2, ['X0' = complex_quartic, 'X1' = [3, 2]]).
answer(2, ['X0' = complex_quartic, 'X1' = [5, 1]]).
query(3, reconstructedPolynomial(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = real_quartic, 'X1' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]]).
answer(3, ['X0' = complex_quartic, 'X1' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]]).
query(4, reconstructionMatches(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 2).
answer(4, ['X0' = real_quartic, 'X1' = true]).
answer(4, ['X0' = complex_quartic, 'X1' = true]).
query(5, allRootsVerified(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 2).
answer(5, ['X0' = real_quartic, 'X1' = true]).
answer(5, ['X0' = complex_quartic, 'X1' = true]).
