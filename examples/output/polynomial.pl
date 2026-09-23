root(real_quartic, [1, 0]).
root(real_quartic, [2, 0]).
root(real_quartic, [3, 0]).
root(real_quartic, [4, 0]).
root(complex_quartic, [0, 1]).
root(complex_quartic, [1, 1]).
root(complex_quartic, [3, 2]).
root(complex_quartic, [5, 1]).
reconstructedPolynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]).
reconstructedPolynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]).
reconstructionMatches(real_quartic, true).
reconstructionMatches(complex_quartic, true).
allRootsVerified(real_quartic, true).
allRootsVerified(complex_quartic, true).
