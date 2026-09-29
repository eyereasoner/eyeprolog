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

clause(3, polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]), true).
clause(4, polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]), true).
clause(5, real_domain(real_quartic, 0, 5), true).
clause(6, imag_domain(real_quartic, 0, 0), true).
clause(7, real_domain(complex_quartic, 0, 5), true).
clause(8, imag_domain(complex_quartic, 0, 2), true).
clause(9, known_roots(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]), true).
clause(10, known_roots(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]), true).
clause(11, c_zero([0, 0]), true).
clause(12,
       c_add([var('A'), var('B')], [var('C'), var('D')], [var('E'), var('F')]),
       (var('E') is var('A') + var('C'), var('F') is var('B') + var('D'))).
clause(14,
       c_neg([var('A'), var('B')], [var('C'), var('D')]),
       (var('C') is - var('A'), var('D') is - var('B'))).
clause(15,
       c_mul([var('A'), var('B')], [var('C'), var('D')], [var('E'), var('F')]),
       (var('Ac') is var('A') * var('C'),
        var('Bd') is var('B') * var('D'),
        var('E') is var('Ac') - var('Bd'),
        var('Ad') is var('A') * var('D'),
        var('Bc') is var('B') * var('C'),
        var('F') is var('Ad') + var('Bc'))).
clause(16,
       poly_eval([var('Coeff') | var('Rest')], var('X'), var('Value')),
       poly_eval_acc(var('Rest'), var('X'), var('Coeff'), var('Value'))).
clause(17, poly_eval_acc([], anonymous(1), var('Acc'), var('Acc')), true).
clause(18,
       poly_eval_acc([var('Coeff') | var('Rest')], var('X'), var('Acc'), var('Value')),
       (c_mul(var('Acc'), var('X'), var('Product')),
        c_add(var('Product'), var('Coeff'), var('Next')),
        poly_eval_acc(var('Rest'), var('X'), var('Next'), var('Value')))).
clause(19,
       candidate(var('Case'), [var('R'), var('I')]),
       (real_domain(var('Case'), var('R0'), var('R1')),
        imag_domain(var('Case'), var('I0'), var('I1')),
        between(var('R0'), var('R1'), var('R')),
        between(var('I0'), var('I1'), var('I')))).
clause(20,
       root(var('Case'), var('Root')),
       (polynomial(var('Case'), var('Coeffs')),
        candidate(var('Case'), var('Root')),
        poly_eval(var('Coeffs'), var('Root'), var('Value')),
        c_zero(var('Value')))).
clause(21,
       poly_from_roots(var('Roots'), var('Coeffs')),
       poly_from_roots_acc(var('Roots'), [[1, 0]], var('Coeffs'))).
clause(22, poly_from_roots_acc([], var('Coeffs'), var('Coeffs')), true).
clause(23,
       poly_from_roots_acc([var('Root') | var('Rest')], var('Coeffs'), var('Result')),
       (poly_mul_linear(var('Coeffs'), var('Root'), var('Next')),
        poly_from_roots_acc(var('Rest'), var('Next'), var('Result')))).
clause(24,
       poly_mul_linear(var('Coeffs'), var('Root'), var('Product')),
       (append(var('Coeffs'), [[0, 0]], var('Shifted')),
        c_neg(var('Root'), var('Minusroot')),
        poly_scale(var('Minusroot'), var('Coeffs'), var('Scaled')),
        append([[0, 0]], var('Scaled'), var('Lower')),
        poly_add(var('Shifted'), var('Lower'), var('Product')))).
clause(25, poly_scale(anonymous(1), [], []), true).
clause(26,
       poly_scale(var('Factor'), [var('Coeff') | var('Rest')], [var('Product') | var('Scaled')]),
       (c_mul(var('Factor'), var('Coeff'), var('Product')),
        poly_scale(var('Factor'), var('Rest'), var('Scaled')))).
clause(27, poly_add([], [], []), true).
clause(28,
       poly_add([var('A') | var('As')], [var('B') | var('Bs')], [var('C') | var('Cs')]),
       (c_add(var('A'), var('B'), var('C')), poly_add(var('As'), var('Bs'), var('Cs')))).
clause(29,
       reconstructed(var('Case'), var('Coeffs')),
       (known_roots(var('Case'), var('Roots')), poly_from_roots(var('Roots'), var('Coeffs')))).
clause(30,
       reconstructedPolynomial(var('Case'), var('Coeffs')),
       reconstructed(var('Case'), var('Coeffs'))).
clause(31,
       reconstructionMatches(var('Case'), true),
       (polynomial(var('Case'), var('Coeffs')), reconstructed(var('Case'), var('Coeffs')))).
clause(32,
       allRootsVerified(var('Case'), true),
       (known_roots(var('Case'), var('Roots')), all_roots_verify(var('Case'), var('Roots')))).
clause(33, all_roots_verify(anonymous(1), []), true).
clause(34,
       all_roots_verify(var('Case'), [var('Root') | var('Rest')]),
       (root(var('Case'), var('Root')), all_roots_verify(var('Case'), var('Rest')))).

step(root(real_quartic, [1, 0]),
     rule(20),
     ['Case' = real_quartic,
      'Root' = [1, 0],
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Value' = [0, 0]],
     [polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      candidate(real_quartic, [1, 0]),
      poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [1, 0], [0, 0]),
      c_zero([0, 0])]).
step(polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]), fact(3), [], []).
step(candidate(real_quartic, [1, 0]),
     rule(19),
     ['Case' = real_quartic, 'R' = 1, 'I' = 0, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 0],
     [real_domain(real_quartic, 0, 5),
      imag_domain(real_quartic, 0, 0),
      between(0, 5, 1),
      between(0, 0, 0)]).
step(real_domain(real_quartic, 0, 5), fact(5), [], []).
step(imag_domain(real_quartic, 0, 0), fact(6), [], []).
step(between(0, 5, 1), builtin, [], []).
step(between(0, 0, 0), builtin, [], []).
step(poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [1, 0], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-10, 0], [35, 0], [-50, 0], [24, 0]],
      'X' = [1, 0],
      'Value' = [0, 0]],
     [poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [1, 0], [1, 0], [0, 0])]).
step(poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [1, 0], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-10, 0],
      'Rest' = [[35, 0], [-50, 0], [24, 0]],
      'X' = [1, 0],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [1, 0],
      'Next' = [-9, 0]],
     [c_mul([1, 0], [1, 0], [1, 0]),
      c_add([1, 0], [-10, 0], [-9, 0]),
      poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [1, 0], [-9, 0], [0, 0])]).
step(c_mul([1, 0], [1, 0], [1, 0]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = 1,
      'F' = 0,
      'Ac' = 1,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [1 is 1 * 1, 0 is 0 * 0, 1 is 1 - 0, 0 is 1 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(1 is 1 * 1, builtin, [], []).
step(0 is 0 * 0, builtin, [], []).
step(1 is 1 - 0, builtin, [], []).
step(0 is 1 * 0, builtin, [], []).
step(0 is 0 * 1, builtin, [], []).
step(0 is 0 + 0, builtin, [], []).
step(c_add([1, 0], [-10, 0], [-9, 0]),
     rule(12),
     ['A' = 1, 'B' = 0, 'C' = -10, 'D' = 0, 'E' = -9, 'F' = 0],
     [-9 is 1 + -10, 0 is 0 + 0]).
step(-9 is 1 + -10, builtin, [], []).
step(poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [1, 0], [-9, 0], [0, 0]),
     rule(18),
     ['Coeff' = [35, 0],
      'Rest' = [[-50, 0], [24, 0]],
      'X' = [1, 0],
      'Acc' = [-9, 0],
      'Value' = [0, 0],
      'Product' = [-9, 0],
      'Next' = [26, 0]],
     [c_mul([-9, 0], [1, 0], [-9, 0]),
      c_add([-9, 0], [35, 0], [26, 0]),
      poly_eval_acc([[-50, 0], [24, 0]], [1, 0], [26, 0], [0, 0])]).
step(c_mul([-9, 0], [1, 0], [-9, 0]),
     rule(15),
     ['A' = -9,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -9,
      'F' = 0,
      'Ac' = -9,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-9 is -9 * 1, 0 is 0 * 0, -9 is -9 - 0, 0 is -9 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-9 is -9 * 1, builtin, [], []).
step(-9 is -9 - 0, builtin, [], []).
step(0 is -9 * 0, builtin, [], []).
step(c_add([-9, 0], [35, 0], [26, 0]),
     rule(12),
     ['A' = -9, 'B' = 0, 'C' = 35, 'D' = 0, 'E' = 26, 'F' = 0],
     [26 is -9 + 35, 0 is 0 + 0]).
step(26 is -9 + 35, builtin, [], []).
step(poly_eval_acc([[-50, 0], [24, 0]], [1, 0], [26, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-50, 0],
      'Rest' = [[24, 0]],
      'X' = [1, 0],
      'Acc' = [26, 0],
      'Value' = [0, 0],
      'Product' = [26, 0],
      'Next' = [-24, 0]],
     [c_mul([26, 0], [1, 0], [26, 0]),
      c_add([26, 0], [-50, 0], [-24, 0]),
      poly_eval_acc([[24, 0]], [1, 0], [-24, 0], [0, 0])]).
step(c_mul([26, 0], [1, 0], [26, 0]),
     rule(15),
     ['A' = 26,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = 26,
      'F' = 0,
      'Ac' = 26,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [26 is 26 * 1, 0 is 0 * 0, 26 is 26 - 0, 0 is 26 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(26 is 26 * 1, builtin, [], []).
step(26 is 26 - 0, builtin, [], []).
step(0 is 26 * 0, builtin, [], []).
step(c_add([26, 0], [-50, 0], [-24, 0]),
     rule(12),
     ['A' = 26, 'B' = 0, 'C' = -50, 'D' = 0, 'E' = -24, 'F' = 0],
     [-24 is 26 + -50, 0 is 0 + 0]).
step(-24 is 26 + -50, builtin, [], []).
step(poly_eval_acc([[24, 0]], [1, 0], [-24, 0], [0, 0]),
     rule(18),
     ['Coeff' = [24, 0],
      'Rest' = [],
      'X' = [1, 0],
      'Acc' = [-24, 0],
      'Value' = [0, 0],
      'Product' = [-24, 0],
      'Next' = [0, 0]],
     [c_mul([-24, 0], [1, 0], [-24, 0]),
      c_add([-24, 0], [24, 0], [0, 0]),
      poly_eval_acc([], [1, 0], [0, 0], [0, 0])]).
step(c_mul([-24, 0], [1, 0], [-24, 0]),
     rule(15),
     ['A' = -24,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -24,
      'F' = 0,
      'Ac' = -24,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-24 is -24 * 1, 0 is 0 * 0, -24 is -24 - 0, 0 is -24 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-24 is -24 * 1, builtin, [], []).
step(-24 is -24 - 0, builtin, [], []).
step(0 is -24 * 0, builtin, [], []).
step(c_add([-24, 0], [24, 0], [0, 0]),
     rule(12),
     ['A' = -24, 'B' = 0, 'C' = 24, 'D' = 0, 'E' = 0, 'F' = 0],
     [0 is -24 + 24, 0 is 0 + 0]).
step(0 is -24 + 24, builtin, [], []).
step(poly_eval_acc([], [1, 0], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(c_zero([0, 0]), fact(11), [], []).
step(root(real_quartic, [2, 0]),
     rule(20),
     ['Case' = real_quartic,
      'Root' = [2, 0],
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Value' = [0, 0]],
     [polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      candidate(real_quartic, [2, 0]),
      poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [2, 0], [0, 0]),
      c_zero([0, 0])]).
step(candidate(real_quartic, [2, 0]),
     rule(19),
     ['Case' = real_quartic, 'R' = 2, 'I' = 0, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 0],
     [real_domain(real_quartic, 0, 5),
      imag_domain(real_quartic, 0, 0),
      between(0, 5, 2),
      between(0, 0, 0)]).
step(between(0, 5, 2), builtin, [], []).
step(poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [2, 0], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-10, 0], [35, 0], [-50, 0], [24, 0]],
      'X' = [2, 0],
      'Value' = [0, 0]],
     [poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [2, 0], [1, 0], [0, 0])]).
step(poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [2, 0], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-10, 0],
      'Rest' = [[35, 0], [-50, 0], [24, 0]],
      'X' = [2, 0],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [2, 0],
      'Next' = [-8, 0]],
     [c_mul([1, 0], [2, 0], [2, 0]),
      c_add([2, 0], [-10, 0], [-8, 0]),
      poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [2, 0], [-8, 0], [0, 0])]).
step(c_mul([1, 0], [2, 0], [2, 0]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 2,
      'D' = 0,
      'E' = 2,
      'F' = 0,
      'Ac' = 2,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [2 is 1 * 2, 0 is 0 * 0, 2 is 2 - 0, 0 is 1 * 0, 0 is 0 * 2, 0 is 0 + 0]).
step(2 is 1 * 2, builtin, [], []).
step(2 is 2 - 0, builtin, [], []).
step(0 is 0 * 2, builtin, [], []).
step(c_add([2, 0], [-10, 0], [-8, 0]),
     rule(12),
     ['A' = 2, 'B' = 0, 'C' = -10, 'D' = 0, 'E' = -8, 'F' = 0],
     [-8 is 2 + -10, 0 is 0 + 0]).
step(-8 is 2 + -10, builtin, [], []).
step(poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [2, 0], [-8, 0], [0, 0]),
     rule(18),
     ['Coeff' = [35, 0],
      'Rest' = [[-50, 0], [24, 0]],
      'X' = [2, 0],
      'Acc' = [-8, 0],
      'Value' = [0, 0],
      'Product' = [-16, 0],
      'Next' = [19, 0]],
     [c_mul([-8, 0], [2, 0], [-16, 0]),
      c_add([-16, 0], [35, 0], [19, 0]),
      poly_eval_acc([[-50, 0], [24, 0]], [2, 0], [19, 0], [0, 0])]).
step(c_mul([-8, 0], [2, 0], [-16, 0]),
     rule(15),
     ['A' = -8,
      'B' = 0,
      'C' = 2,
      'D' = 0,
      'E' = -16,
      'F' = 0,
      'Ac' = -16,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-16 is -8 * 2, 0 is 0 * 0, -16 is -16 - 0, 0 is -8 * 0, 0 is 0 * 2, 0 is 0 + 0]).
step(-16 is -8 * 2, builtin, [], []).
step(-16 is -16 - 0, builtin, [], []).
step(0 is -8 * 0, builtin, [], []).
step(c_add([-16, 0], [35, 0], [19, 0]),
     rule(12),
     ['A' = -16, 'B' = 0, 'C' = 35, 'D' = 0, 'E' = 19, 'F' = 0],
     [19 is -16 + 35, 0 is 0 + 0]).
step(19 is -16 + 35, builtin, [], []).
step(poly_eval_acc([[-50, 0], [24, 0]], [2, 0], [19, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-50, 0],
      'Rest' = [[24, 0]],
      'X' = [2, 0],
      'Acc' = [19, 0],
      'Value' = [0, 0],
      'Product' = [38, 0],
      'Next' = [-12, 0]],
     [c_mul([19, 0], [2, 0], [38, 0]),
      c_add([38, 0], [-50, 0], [-12, 0]),
      poly_eval_acc([[24, 0]], [2, 0], [-12, 0], [0, 0])]).
step(c_mul([19, 0], [2, 0], [38, 0]),
     rule(15),
     ['A' = 19,
      'B' = 0,
      'C' = 2,
      'D' = 0,
      'E' = 38,
      'F' = 0,
      'Ac' = 38,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [38 is 19 * 2, 0 is 0 * 0, 38 is 38 - 0, 0 is 19 * 0, 0 is 0 * 2, 0 is 0 + 0]).
step(38 is 19 * 2, builtin, [], []).
step(38 is 38 - 0, builtin, [], []).
step(0 is 19 * 0, builtin, [], []).
step(c_add([38, 0], [-50, 0], [-12, 0]),
     rule(12),
     ['A' = 38, 'B' = 0, 'C' = -50, 'D' = 0, 'E' = -12, 'F' = 0],
     [-12 is 38 + -50, 0 is 0 + 0]).
step(-12 is 38 + -50, builtin, [], []).
step(poly_eval_acc([[24, 0]], [2, 0], [-12, 0], [0, 0]),
     rule(18),
     ['Coeff' = [24, 0],
      'Rest' = [],
      'X' = [2, 0],
      'Acc' = [-12, 0],
      'Value' = [0, 0],
      'Product' = [-24, 0],
      'Next' = [0, 0]],
     [c_mul([-12, 0], [2, 0], [-24, 0]),
      c_add([-24, 0], [24, 0], [0, 0]),
      poly_eval_acc([], [2, 0], [0, 0], [0, 0])]).
step(c_mul([-12, 0], [2, 0], [-24, 0]),
     rule(15),
     ['A' = -12,
      'B' = 0,
      'C' = 2,
      'D' = 0,
      'E' = -24,
      'F' = 0,
      'Ac' = -24,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-24 is -12 * 2, 0 is 0 * 0, -24 is -24 - 0, 0 is -12 * 0, 0 is 0 * 2, 0 is 0 + 0]).
step(-24 is -12 * 2, builtin, [], []).
step(0 is -12 * 0, builtin, [], []).
step(poly_eval_acc([], [2, 0], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(real_quartic, [3, 0]),
     rule(20),
     ['Case' = real_quartic,
      'Root' = [3, 0],
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Value' = [0, 0]],
     [polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      candidate(real_quartic, [3, 0]),
      poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [3, 0], [0, 0]),
      c_zero([0, 0])]).
step(candidate(real_quartic, [3, 0]),
     rule(19),
     ['Case' = real_quartic, 'R' = 3, 'I' = 0, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 0],
     [real_domain(real_quartic, 0, 5),
      imag_domain(real_quartic, 0, 0),
      between(0, 5, 3),
      between(0, 0, 0)]).
step(between(0, 5, 3), builtin, [], []).
step(poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [3, 0], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-10, 0], [35, 0], [-50, 0], [24, 0]],
      'X' = [3, 0],
      'Value' = [0, 0]],
     [poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [3, 0], [1, 0], [0, 0])]).
step(poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [3, 0], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-10, 0],
      'Rest' = [[35, 0], [-50, 0], [24, 0]],
      'X' = [3, 0],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [3, 0],
      'Next' = [-7, 0]],
     [c_mul([1, 0], [3, 0], [3, 0]),
      c_add([3, 0], [-10, 0], [-7, 0]),
      poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [3, 0], [-7, 0], [0, 0])]).
step(c_mul([1, 0], [3, 0], [3, 0]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 3,
      'D' = 0,
      'E' = 3,
      'F' = 0,
      'Ac' = 3,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [3 is 1 * 3, 0 is 0 * 0, 3 is 3 - 0, 0 is 1 * 0, 0 is 0 * 3, 0 is 0 + 0]).
step(3 is 1 * 3, builtin, [], []).
step(3 is 3 - 0, builtin, [], []).
step(0 is 0 * 3, builtin, [], []).
step(c_add([3, 0], [-10, 0], [-7, 0]),
     rule(12),
     ['A' = 3, 'B' = 0, 'C' = -10, 'D' = 0, 'E' = -7, 'F' = 0],
     [-7 is 3 + -10, 0 is 0 + 0]).
step(-7 is 3 + -10, builtin, [], []).
step(poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [3, 0], [-7, 0], [0, 0]),
     rule(18),
     ['Coeff' = [35, 0],
      'Rest' = [[-50, 0], [24, 0]],
      'X' = [3, 0],
      'Acc' = [-7, 0],
      'Value' = [0, 0],
      'Product' = [-21, 0],
      'Next' = [14, 0]],
     [c_mul([-7, 0], [3, 0], [-21, 0]),
      c_add([-21, 0], [35, 0], [14, 0]),
      poly_eval_acc([[-50, 0], [24, 0]], [3, 0], [14, 0], [0, 0])]).
step(c_mul([-7, 0], [3, 0], [-21, 0]),
     rule(15),
     ['A' = -7,
      'B' = 0,
      'C' = 3,
      'D' = 0,
      'E' = -21,
      'F' = 0,
      'Ac' = -21,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-21 is -7 * 3, 0 is 0 * 0, -21 is -21 - 0, 0 is -7 * 0, 0 is 0 * 3, 0 is 0 + 0]).
step(-21 is -7 * 3, builtin, [], []).
step(-21 is -21 - 0, builtin, [], []).
step(0 is -7 * 0, builtin, [], []).
step(c_add([-21, 0], [35, 0], [14, 0]),
     rule(12),
     ['A' = -21, 'B' = 0, 'C' = 35, 'D' = 0, 'E' = 14, 'F' = 0],
     [14 is -21 + 35, 0 is 0 + 0]).
step(14 is -21 + 35, builtin, [], []).
step(poly_eval_acc([[-50, 0], [24, 0]], [3, 0], [14, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-50, 0],
      'Rest' = [[24, 0]],
      'X' = [3, 0],
      'Acc' = [14, 0],
      'Value' = [0, 0],
      'Product' = [42, 0],
      'Next' = [-8, 0]],
     [c_mul([14, 0], [3, 0], [42, 0]),
      c_add([42, 0], [-50, 0], [-8, 0]),
      poly_eval_acc([[24, 0]], [3, 0], [-8, 0], [0, 0])]).
step(c_mul([14, 0], [3, 0], [42, 0]),
     rule(15),
     ['A' = 14,
      'B' = 0,
      'C' = 3,
      'D' = 0,
      'E' = 42,
      'F' = 0,
      'Ac' = 42,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [42 is 14 * 3, 0 is 0 * 0, 42 is 42 - 0, 0 is 14 * 0, 0 is 0 * 3, 0 is 0 + 0]).
step(42 is 14 * 3, builtin, [], []).
step(42 is 42 - 0, builtin, [], []).
step(0 is 14 * 0, builtin, [], []).
step(c_add([42, 0], [-50, 0], [-8, 0]),
     rule(12),
     ['A' = 42, 'B' = 0, 'C' = -50, 'D' = 0, 'E' = -8, 'F' = 0],
     [-8 is 42 + -50, 0 is 0 + 0]).
step(-8 is 42 + -50, builtin, [], []).
step(poly_eval_acc([[24, 0]], [3, 0], [-8, 0], [0, 0]),
     rule(18),
     ['Coeff' = [24, 0],
      'Rest' = [],
      'X' = [3, 0],
      'Acc' = [-8, 0],
      'Value' = [0, 0],
      'Product' = [-24, 0],
      'Next' = [0, 0]],
     [c_mul([-8, 0], [3, 0], [-24, 0]),
      c_add([-24, 0], [24, 0], [0, 0]),
      poly_eval_acc([], [3, 0], [0, 0], [0, 0])]).
step(c_mul([-8, 0], [3, 0], [-24, 0]),
     rule(15),
     ['A' = -8,
      'B' = 0,
      'C' = 3,
      'D' = 0,
      'E' = -24,
      'F' = 0,
      'Ac' = -24,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-24 is -8 * 3, 0 is 0 * 0, -24 is -24 - 0, 0 is -8 * 0, 0 is 0 * 3, 0 is 0 + 0]).
step(-24 is -8 * 3, builtin, [], []).
step(poly_eval_acc([], [3, 0], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(real_quartic, [4, 0]),
     rule(20),
     ['Case' = real_quartic,
      'Root' = [4, 0],
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Value' = [0, 0]],
     [polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      candidate(real_quartic, [4, 0]),
      poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [4, 0], [0, 0]),
      c_zero([0, 0])]).
step(candidate(real_quartic, [4, 0]),
     rule(19),
     ['Case' = real_quartic, 'R' = 4, 'I' = 0, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 0],
     [real_domain(real_quartic, 0, 5),
      imag_domain(real_quartic, 0, 0),
      between(0, 5, 4),
      between(0, 0, 0)]).
step(between(0, 5, 4), builtin, [], []).
step(poly_eval([[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [4, 0], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-10, 0], [35, 0], [-50, 0], [24, 0]],
      'X' = [4, 0],
      'Value' = [0, 0]],
     [poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [4, 0], [1, 0], [0, 0])]).
step(poly_eval_acc([[-10, 0], [35, 0], [-50, 0], [24, 0]], [4, 0], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-10, 0],
      'Rest' = [[35, 0], [-50, 0], [24, 0]],
      'X' = [4, 0],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [4, 0],
      'Next' = [-6, 0]],
     [c_mul([1, 0], [4, 0], [4, 0]),
      c_add([4, 0], [-10, 0], [-6, 0]),
      poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [4, 0], [-6, 0], [0, 0])]).
step(c_mul([1, 0], [4, 0], [4, 0]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 4,
      'D' = 0,
      'E' = 4,
      'F' = 0,
      'Ac' = 4,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [4 is 1 * 4, 0 is 0 * 0, 4 is 4 - 0, 0 is 1 * 0, 0 is 0 * 4, 0 is 0 + 0]).
step(4 is 1 * 4, builtin, [], []).
step(4 is 4 - 0, builtin, [], []).
step(0 is 0 * 4, builtin, [], []).
step(c_add([4, 0], [-10, 0], [-6, 0]),
     rule(12),
     ['A' = 4, 'B' = 0, 'C' = -10, 'D' = 0, 'E' = -6, 'F' = 0],
     [-6 is 4 + -10, 0 is 0 + 0]).
step(-6 is 4 + -10, builtin, [], []).
step(poly_eval_acc([[35, 0], [-50, 0], [24, 0]], [4, 0], [-6, 0], [0, 0]),
     rule(18),
     ['Coeff' = [35, 0],
      'Rest' = [[-50, 0], [24, 0]],
      'X' = [4, 0],
      'Acc' = [-6, 0],
      'Value' = [0, 0],
      'Product' = [-24, 0],
      'Next' = [11, 0]],
     [c_mul([-6, 0], [4, 0], [-24, 0]),
      c_add([-24, 0], [35, 0], [11, 0]),
      poly_eval_acc([[-50, 0], [24, 0]], [4, 0], [11, 0], [0, 0])]).
step(c_mul([-6, 0], [4, 0], [-24, 0]),
     rule(15),
     ['A' = -6,
      'B' = 0,
      'C' = 4,
      'D' = 0,
      'E' = -24,
      'F' = 0,
      'Ac' = -24,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-24 is -6 * 4, 0 is 0 * 0, -24 is -24 - 0, 0 is -6 * 0, 0 is 0 * 4, 0 is 0 + 0]).
step(-24 is -6 * 4, builtin, [], []).
step(0 is -6 * 0, builtin, [], []).
step(c_add([-24, 0], [35, 0], [11, 0]),
     rule(12),
     ['A' = -24, 'B' = 0, 'C' = 35, 'D' = 0, 'E' = 11, 'F' = 0],
     [11 is -24 + 35, 0 is 0 + 0]).
step(11 is -24 + 35, builtin, [], []).
step(poly_eval_acc([[-50, 0], [24, 0]], [4, 0], [11, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-50, 0],
      'Rest' = [[24, 0]],
      'X' = [4, 0],
      'Acc' = [11, 0],
      'Value' = [0, 0],
      'Product' = [44, 0],
      'Next' = [-6, 0]],
     [c_mul([11, 0], [4, 0], [44, 0]),
      c_add([44, 0], [-50, 0], [-6, 0]),
      poly_eval_acc([[24, 0]], [4, 0], [-6, 0], [0, 0])]).
step(c_mul([11, 0], [4, 0], [44, 0]),
     rule(15),
     ['A' = 11,
      'B' = 0,
      'C' = 4,
      'D' = 0,
      'E' = 44,
      'F' = 0,
      'Ac' = 44,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [44 is 11 * 4, 0 is 0 * 0, 44 is 44 - 0, 0 is 11 * 0, 0 is 0 * 4, 0 is 0 + 0]).
step(44 is 11 * 4, builtin, [], []).
step(44 is 44 - 0, builtin, [], []).
step(0 is 11 * 0, builtin, [], []).
step(c_add([44, 0], [-50, 0], [-6, 0]),
     rule(12),
     ['A' = 44, 'B' = 0, 'C' = -50, 'D' = 0, 'E' = -6, 'F' = 0],
     [-6 is 44 + -50, 0 is 0 + 0]).
step(-6 is 44 + -50, builtin, [], []).
step(poly_eval_acc([[24, 0]], [4, 0], [-6, 0], [0, 0]),
     rule(18),
     ['Coeff' = [24, 0],
      'Rest' = [],
      'X' = [4, 0],
      'Acc' = [-6, 0],
      'Value' = [0, 0],
      'Product' = [-24, 0],
      'Next' = [0, 0]],
     [c_mul([-6, 0], [4, 0], [-24, 0]),
      c_add([-24, 0], [24, 0], [0, 0]),
      poly_eval_acc([], [4, 0], [0, 0], [0, 0])]).
step(poly_eval_acc([], [4, 0], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(complex_quartic, [0, 1]),
     rule(20),
     ['Case' = complex_quartic,
      'Root' = [0, 1],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Value' = [0, 0]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      candidate(complex_quartic, [0, 1]),
      poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [0, 1], [0, 0]),
      c_zero([0, 0])]).
step(polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     fact(4),
     [],
     []).
step(candidate(complex_quartic, [0, 1]),
     rule(19),
     ['Case' = complex_quartic, 'R' = 0, 'I' = 1, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 2],
     [real_domain(complex_quartic, 0, 5),
      imag_domain(complex_quartic, 0, 2),
      between(0, 5, 0),
      between(0, 2, 1)]).
step(real_domain(complex_quartic, 0, 5), fact(7), [], []).
step(imag_domain(complex_quartic, 0, 2), fact(8), [], []).
step(between(0, 5, 0), builtin, [], []).
step(between(0, 2, 1), builtin, [], []).
step(poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [0, 1], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-9, -5], [14, 33], [24, -44], [-26, 0]],
      'X' = [0, 1],
      'Value' = [0, 0]],
     [poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [0, 1], [1, 0], [0, 0])]).
step(poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [0, 1], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-9, -5],
      'Rest' = [[14, 33], [24, -44], [-26, 0]],
      'X' = [0, 1],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [0, 1],
      'Next' = [-9, -4]],
     [c_mul([1, 0], [0, 1], [0, 1]),
      c_add([0, 1], [-9, -5], [-9, -4]),
      poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [0, 1], [-9, -4], [0, 0])]).
step(c_mul([1, 0], [0, 1], [0, 1]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 0,
      'D' = 1,
      'E' = 0,
      'F' = 1,
      'Ac' = 0,
      'Bd' = 0,
      'Ad' = 1,
      'Bc' = 0],
     [0 is 1 * 0, 0 is 0 * 1, 0 is 0 - 0, 1 is 1 * 1, 0 is 0 * 0, 1 is 1 + 0]).
step(0 is 0 - 0, builtin, [], []).
step(1 is 1 + 0, builtin, [], []).
step(c_add([0, 1], [-9, -5], [-9, -4]),
     rule(12),
     ['A' = 0, 'B' = 1, 'C' = -9, 'D' = -5, 'E' = -9, 'F' = -4],
     [-9 is 0 + -9, -4 is 1 + -5]).
step(-9 is 0 + -9, builtin, [], []).
step(-4 is 1 + -5, builtin, [], []).
step(poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [0, 1], [-9, -4], [0, 0]),
     rule(18),
     ['Coeff' = [14, 33],
      'Rest' = [[24, -44], [-26, 0]],
      'X' = [0, 1],
      'Acc' = [-9, -4],
      'Value' = [0, 0],
      'Product' = [4, -9],
      'Next' = [18, 24]],
     [c_mul([-9, -4], [0, 1], [4, -9]),
      c_add([4, -9], [14, 33], [18, 24]),
      poly_eval_acc([[24, -44], [-26, 0]], [0, 1], [18, 24], [0, 0])]).
step(c_mul([-9, -4], [0, 1], [4, -9]),
     rule(15),
     ['A' = -9,
      'B' = -4,
      'C' = 0,
      'D' = 1,
      'E' = 4,
      'F' = -9,
      'Ac' = 0,
      'Bd' = -4,
      'Ad' = -9,
      'Bc' = 0],
     [0 is -9 * 0, -4 is -4 * 1, 4 is 0 - -4, -9 is -9 * 1, 0 is -4 * 0, -9 is -9 + 0]).
step(-4 is -4 * 1, builtin, [], []).
step(4 is 0 - -4, builtin, [], []).
step(0 is -4 * 0, builtin, [], []).
step(-9 is -9 + 0, builtin, [], []).
step(c_add([4, -9], [14, 33], [18, 24]),
     rule(12),
     ['A' = 4, 'B' = -9, 'C' = 14, 'D' = 33, 'E' = 18, 'F' = 24],
     [18 is 4 + 14, 24 is -9 + 33]).
step(18 is 4 + 14, builtin, [], []).
step(24 is -9 + 33, builtin, [], []).
step(poly_eval_acc([[24, -44], [-26, 0]], [0, 1], [18, 24], [0, 0]),
     rule(18),
     ['Coeff' = [24, -44],
      'Rest' = [[-26, 0]],
      'X' = [0, 1],
      'Acc' = [18, 24],
      'Value' = [0, 0],
      'Product' = [-24, 18],
      'Next' = [0, -26]],
     [c_mul([18, 24], [0, 1], [-24, 18]),
      c_add([-24, 18], [24, -44], [0, -26]),
      poly_eval_acc([[-26, 0]], [0, 1], [0, -26], [0, 0])]).
step(c_mul([18, 24], [0, 1], [-24, 18]),
     rule(15),
     ['A' = 18,
      'B' = 24,
      'C' = 0,
      'D' = 1,
      'E' = -24,
      'F' = 18,
      'Ac' = 0,
      'Bd' = 24,
      'Ad' = 18,
      'Bc' = 0],
     [0 is 18 * 0, 24 is 24 * 1, -24 is 0 - 24, 18 is 18 * 1, 0 is 24 * 0, 18 is 18 + 0]).
step(0 is 18 * 0, builtin, [], []).
step(24 is 24 * 1, builtin, [], []).
step(-24 is 0 - 24, builtin, [], []).
step(18 is 18 * 1, builtin, [], []).
step(0 is 24 * 0, builtin, [], []).
step(18 is 18 + 0, builtin, [], []).
step(c_add([-24, 18], [24, -44], [0, -26]),
     rule(12),
     ['A' = -24, 'B' = 18, 'C' = 24, 'D' = -44, 'E' = 0, 'F' = -26],
     [0 is -24 + 24, -26 is 18 + -44]).
step(-26 is 18 + -44, builtin, [], []).
step(poly_eval_acc([[-26, 0]], [0, 1], [0, -26], [0, 0]),
     rule(18),
     ['Coeff' = [-26, 0],
      'Rest' = [],
      'X' = [0, 1],
      'Acc' = [0, -26],
      'Value' = [0, 0],
      'Product' = [26, 0],
      'Next' = [0, 0]],
     [c_mul([0, -26], [0, 1], [26, 0]),
      c_add([26, 0], [-26, 0], [0, 0]),
      poly_eval_acc([], [0, 1], [0, 0], [0, 0])]).
step(c_mul([0, -26], [0, 1], [26, 0]),
     rule(15),
     ['A' = 0,
      'B' = -26,
      'C' = 0,
      'D' = 1,
      'E' = 26,
      'F' = 0,
      'Ac' = 0,
      'Bd' = -26,
      'Ad' = 0,
      'Bc' = 0],
     [0 is 0 * 0, -26 is -26 * 1, 26 is 0 - -26, 0 is 0 * 1, 0 is -26 * 0, 0 is 0 + 0]).
step(-26 is -26 * 1, builtin, [], []).
step(26 is 0 - -26, builtin, [], []).
step(0 is -26 * 0, builtin, [], []).
step(c_add([26, 0], [-26, 0], [0, 0]),
     rule(12),
     ['A' = 26, 'B' = 0, 'C' = -26, 'D' = 0, 'E' = 0, 'F' = 0],
     [0 is 26 + -26, 0 is 0 + 0]).
step(0 is 26 + -26, builtin, [], []).
step(poly_eval_acc([], [0, 1], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(complex_quartic, [1, 1]),
     rule(20),
     ['Case' = complex_quartic,
      'Root' = [1, 1],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Value' = [0, 0]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      candidate(complex_quartic, [1, 1]),
      poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [1, 1], [0, 0]),
      c_zero([0, 0])]).
step(candidate(complex_quartic, [1, 1]),
     rule(19),
     ['Case' = complex_quartic, 'R' = 1, 'I' = 1, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 2],
     [real_domain(complex_quartic, 0, 5),
      imag_domain(complex_quartic, 0, 2),
      between(0, 5, 1),
      between(0, 2, 1)]).
step(poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [1, 1], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-9, -5], [14, 33], [24, -44], [-26, 0]],
      'X' = [1, 1],
      'Value' = [0, 0]],
     [poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [1, 1], [1, 0], [0, 0])]).
step(poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [1, 1], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-9, -5],
      'Rest' = [[14, 33], [24, -44], [-26, 0]],
      'X' = [1, 1],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [1, 1],
      'Next' = [-8, -4]],
     [c_mul([1, 0], [1, 1], [1, 1]),
      c_add([1, 1], [-9, -5], [-8, -4]),
      poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [1, 1], [-8, -4], [0, 0])]).
step(c_mul([1, 0], [1, 1], [1, 1]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 1,
      'D' = 1,
      'E' = 1,
      'F' = 1,
      'Ac' = 1,
      'Bd' = 0,
      'Ad' = 1,
      'Bc' = 0],
     [1 is 1 * 1, 0 is 0 * 1, 1 is 1 - 0, 1 is 1 * 1, 0 is 0 * 1, 1 is 1 + 0]).
step(c_add([1, 1], [-9, -5], [-8, -4]),
     rule(12),
     ['A' = 1, 'B' = 1, 'C' = -9, 'D' = -5, 'E' = -8, 'F' = -4],
     [-8 is 1 + -9, -4 is 1 + -5]).
step(-8 is 1 + -9, builtin, [], []).
step(poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [1, 1], [-8, -4], [0, 0]),
     rule(18),
     ['Coeff' = [14, 33],
      'Rest' = [[24, -44], [-26, 0]],
      'X' = [1, 1],
      'Acc' = [-8, -4],
      'Value' = [0, 0],
      'Product' = [-4, -12],
      'Next' = [10, 21]],
     [c_mul([-8, -4], [1, 1], [-4, -12]),
      c_add([-4, -12], [14, 33], [10, 21]),
      poly_eval_acc([[24, -44], [-26, 0]], [1, 1], [10, 21], [0, 0])]).
step(c_mul([-8, -4], [1, 1], [-4, -12]),
     rule(15),
     ['A' = -8,
      'B' = -4,
      'C' = 1,
      'D' = 1,
      'E' = -4,
      'F' = -12,
      'Ac' = -8,
      'Bd' = -4,
      'Ad' = -8,
      'Bc' = -4],
     [-8 is -8 * 1, -4 is -4 * 1, -4 is -8 - -4, -8 is -8 * 1, -4 is -4 * 1, -12 is -8 + -4]).
step(-8 is -8 * 1, builtin, [], []).
step(-4 is -8 - -4, builtin, [], []).
step(-12 is -8 + -4, builtin, [], []).
step(c_add([-4, -12], [14, 33], [10, 21]),
     rule(12),
     ['A' = -4, 'B' = -12, 'C' = 14, 'D' = 33, 'E' = 10, 'F' = 21],
     [10 is -4 + 14, 21 is -12 + 33]).
step(10 is -4 + 14, builtin, [], []).
step(21 is -12 + 33, builtin, [], []).
step(poly_eval_acc([[24, -44], [-26, 0]], [1, 1], [10, 21], [0, 0]),
     rule(18),
     ['Coeff' = [24, -44],
      'Rest' = [[-26, 0]],
      'X' = [1, 1],
      'Acc' = [10, 21],
      'Value' = [0, 0],
      'Product' = [-11, 31],
      'Next' = [13, -13]],
     [c_mul([10, 21], [1, 1], [-11, 31]),
      c_add([-11, 31], [24, -44], [13, -13]),
      poly_eval_acc([[-26, 0]], [1, 1], [13, -13], [0, 0])]).
step(c_mul([10, 21], [1, 1], [-11, 31]),
     rule(15),
     ['A' = 10,
      'B' = 21,
      'C' = 1,
      'D' = 1,
      'E' = -11,
      'F' = 31,
      'Ac' = 10,
      'Bd' = 21,
      'Ad' = 10,
      'Bc' = 21],
     [10 is 10 * 1, 21 is 21 * 1, -11 is 10 - 21, 10 is 10 * 1, 21 is 21 * 1, 31 is 10 + 21]).
step(10 is 10 * 1, builtin, [], []).
step(21 is 21 * 1, builtin, [], []).
step(-11 is 10 - 21, builtin, [], []).
step(31 is 10 + 21, builtin, [], []).
step(c_add([-11, 31], [24, -44], [13, -13]),
     rule(12),
     ['A' = -11, 'B' = 31, 'C' = 24, 'D' = -44, 'E' = 13, 'F' = -13],
     [13 is -11 + 24, -13 is 31 + -44]).
step(13 is -11 + 24, builtin, [], []).
step(-13 is 31 + -44, builtin, [], []).
step(poly_eval_acc([[-26, 0]], [1, 1], [13, -13], [0, 0]),
     rule(18),
     ['Coeff' = [-26, 0],
      'Rest' = [],
      'X' = [1, 1],
      'Acc' = [13, -13],
      'Value' = [0, 0],
      'Product' = [26, 0],
      'Next' = [0, 0]],
     [c_mul([13, -13], [1, 1], [26, 0]),
      c_add([26, 0], [-26, 0], [0, 0]),
      poly_eval_acc([], [1, 1], [0, 0], [0, 0])]).
step(c_mul([13, -13], [1, 1], [26, 0]),
     rule(15),
     ['A' = 13,
      'B' = -13,
      'C' = 1,
      'D' = 1,
      'E' = 26,
      'F' = 0,
      'Ac' = 13,
      'Bd' = -13,
      'Ad' = 13,
      'Bc' = -13],
     [13 is 13 * 1, -13 is -13 * 1, 26 is 13 - -13, 13 is 13 * 1, -13 is -13 * 1, 0 is 13 + -13]).
step(13 is 13 * 1, builtin, [], []).
step(-13 is -13 * 1, builtin, [], []).
step(26 is 13 - -13, builtin, [], []).
step(0 is 13 + -13, builtin, [], []).
step(poly_eval_acc([], [1, 1], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(complex_quartic, [3, 2]),
     rule(20),
     ['Case' = complex_quartic,
      'Root' = [3, 2],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Value' = [0, 0]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      candidate(complex_quartic, [3, 2]),
      poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [3, 2], [0, 0]),
      c_zero([0, 0])]).
step(candidate(complex_quartic, [3, 2]),
     rule(19),
     ['Case' = complex_quartic, 'R' = 3, 'I' = 2, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 2],
     [real_domain(complex_quartic, 0, 5),
      imag_domain(complex_quartic, 0, 2),
      between(0, 5, 3),
      between(0, 2, 2)]).
step(between(0, 2, 2), builtin, [], []).
step(poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [3, 2], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-9, -5], [14, 33], [24, -44], [-26, 0]],
      'X' = [3, 2],
      'Value' = [0, 0]],
     [poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [3, 2], [1, 0], [0, 0])]).
step(poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [3, 2], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-9, -5],
      'Rest' = [[14, 33], [24, -44], [-26, 0]],
      'X' = [3, 2],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [3, 2],
      'Next' = [-6, -3]],
     [c_mul([1, 0], [3, 2], [3, 2]),
      c_add([3, 2], [-9, -5], [-6, -3]),
      poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [3, 2], [-6, -3], [0, 0])]).
step(c_mul([1, 0], [3, 2], [3, 2]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 3,
      'D' = 2,
      'E' = 3,
      'F' = 2,
      'Ac' = 3,
      'Bd' = 0,
      'Ad' = 2,
      'Bc' = 0],
     [3 is 1 * 3, 0 is 0 * 2, 3 is 3 - 0, 2 is 1 * 2, 0 is 0 * 3, 2 is 2 + 0]).
step(2 is 2 + 0, builtin, [], []).
step(c_add([3, 2], [-9, -5], [-6, -3]),
     rule(12),
     ['A' = 3, 'B' = 2, 'C' = -9, 'D' = -5, 'E' = -6, 'F' = -3],
     [-6 is 3 + -9, -3 is 2 + -5]).
step(-6 is 3 + -9, builtin, [], []).
step(-3 is 2 + -5, builtin, [], []).
step(poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [3, 2], [-6, -3], [0, 0]),
     rule(18),
     ['Coeff' = [14, 33],
      'Rest' = [[24, -44], [-26, 0]],
      'X' = [3, 2],
      'Acc' = [-6, -3],
      'Value' = [0, 0],
      'Product' = [-12, -21],
      'Next' = [2, 12]],
     [c_mul([-6, -3], [3, 2], [-12, -21]),
      c_add([-12, -21], [14, 33], [2, 12]),
      poly_eval_acc([[24, -44], [-26, 0]], [3, 2], [2, 12], [0, 0])]).
step(c_mul([-6, -3], [3, 2], [-12, -21]),
     rule(15),
     ['A' = -6,
      'B' = -3,
      'C' = 3,
      'D' = 2,
      'E' = -12,
      'F' = -21,
      'Ac' = -18,
      'Bd' = -6,
      'Ad' = -12,
      'Bc' = -9],
     [-18 is -6 * 3,
      -6 is -3 * 2,
      -12 is -18 - -6,
      -12 is -6 * 2,
      -9 is -3 * 3,
      -21 is -12 + -9]).
step(-18 is -6 * 3, builtin, [], []).
step(-6 is -3 * 2, builtin, [], []).
step(-12 is -18 - -6, builtin, [], []).
step(-12 is -6 * 2, builtin, [], []).
step(-9 is -3 * 3, builtin, [], []).
step(-21 is -12 + -9, builtin, [], []).
step(c_add([-12, -21], [14, 33], [2, 12]),
     rule(12),
     ['A' = -12, 'B' = -21, 'C' = 14, 'D' = 33, 'E' = 2, 'F' = 12],
     [2 is -12 + 14, 12 is -21 + 33]).
step(2 is -12 + 14, builtin, [], []).
step(12 is -21 + 33, builtin, [], []).
step(poly_eval_acc([[24, -44], [-26, 0]], [3, 2], [2, 12], [0, 0]),
     rule(18),
     ['Coeff' = [24, -44],
      'Rest' = [[-26, 0]],
      'X' = [3, 2],
      'Acc' = [2, 12],
      'Value' = [0, 0],
      'Product' = [-18, 40],
      'Next' = [6, -4]],
     [c_mul([2, 12], [3, 2], [-18, 40]),
      c_add([-18, 40], [24, -44], [6, -4]),
      poly_eval_acc([[-26, 0]], [3, 2], [6, -4], [0, 0])]).
step(c_mul([2, 12], [3, 2], [-18, 40]),
     rule(15),
     ['A' = 2,
      'B' = 12,
      'C' = 3,
      'D' = 2,
      'E' = -18,
      'F' = 40,
      'Ac' = 6,
      'Bd' = 24,
      'Ad' = 4,
      'Bc' = 36],
     [6 is 2 * 3, 24 is 12 * 2, -18 is 6 - 24, 4 is 2 * 2, 36 is 12 * 3, 40 is 4 + 36]).
step(6 is 2 * 3, builtin, [], []).
step(24 is 12 * 2, builtin, [], []).
step(-18 is 6 - 24, builtin, [], []).
step(4 is 2 * 2, builtin, [], []).
step(36 is 12 * 3, builtin, [], []).
step(40 is 4 + 36, builtin, [], []).
step(c_add([-18, 40], [24, -44], [6, -4]),
     rule(12),
     ['A' = -18, 'B' = 40, 'C' = 24, 'D' = -44, 'E' = 6, 'F' = -4],
     [6 is -18 + 24, -4 is 40 + -44]).
step(6 is -18 + 24, builtin, [], []).
step(-4 is 40 + -44, builtin, [], []).
step(poly_eval_acc([[-26, 0]], [3, 2], [6, -4], [0, 0]),
     rule(18),
     ['Coeff' = [-26, 0],
      'Rest' = [],
      'X' = [3, 2],
      'Acc' = [6, -4],
      'Value' = [0, 0],
      'Product' = [26, 0],
      'Next' = [0, 0]],
     [c_mul([6, -4], [3, 2], [26, 0]),
      c_add([26, 0], [-26, 0], [0, 0]),
      poly_eval_acc([], [3, 2], [0, 0], [0, 0])]).
step(c_mul([6, -4], [3, 2], [26, 0]),
     rule(15),
     ['A' = 6,
      'B' = -4,
      'C' = 3,
      'D' = 2,
      'E' = 26,
      'F' = 0,
      'Ac' = 18,
      'Bd' = -8,
      'Ad' = 12,
      'Bc' = -12],
     [18 is 6 * 3, -8 is -4 * 2, 26 is 18 - -8, 12 is 6 * 2, -12 is -4 * 3, 0 is 12 + -12]).
step(18 is 6 * 3, builtin, [], []).
step(-8 is -4 * 2, builtin, [], []).
step(26 is 18 - -8, builtin, [], []).
step(12 is 6 * 2, builtin, [], []).
step(-12 is -4 * 3, builtin, [], []).
step(0 is 12 + -12, builtin, [], []).
step(poly_eval_acc([], [3, 2], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(root(complex_quartic, [5, 1]),
     rule(20),
     ['Case' = complex_quartic,
      'Root' = [5, 1],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Value' = [0, 0]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      candidate(complex_quartic, [5, 1]),
      poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [5, 1], [0, 0]),
      c_zero([0, 0])]).
step(candidate(complex_quartic, [5, 1]),
     rule(19),
     ['Case' = complex_quartic, 'R' = 5, 'I' = 1, 'R0' = 0, 'R1' = 5, 'I0' = 0, 'I1' = 2],
     [real_domain(complex_quartic, 0, 5),
      imag_domain(complex_quartic, 0, 2),
      between(0, 5, 5),
      between(0, 2, 1)]).
step(between(0, 5, 5), builtin, [], []).
step(poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [5, 1], [0, 0]),
     rule(16),
     ['Coeff' = [1, 0],
      'Rest' = [[-9, -5], [14, 33], [24, -44], [-26, 0]],
      'X' = [5, 1],
      'Value' = [0, 0]],
     [poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [5, 1], [1, 0], [0, 0])]).
step(poly_eval_acc([[-9, -5], [14, 33], [24, -44], [-26, 0]], [5, 1], [1, 0], [0, 0]),
     rule(18),
     ['Coeff' = [-9, -5],
      'Rest' = [[14, 33], [24, -44], [-26, 0]],
      'X' = [5, 1],
      'Acc' = [1, 0],
      'Value' = [0, 0],
      'Product' = [5, 1],
      'Next' = [-4, -4]],
     [c_mul([1, 0], [5, 1], [5, 1]),
      c_add([5, 1], [-9, -5], [-4, -4]),
      poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [5, 1], [-4, -4], [0, 0])]).
step(c_mul([1, 0], [5, 1], [5, 1]),
     rule(15),
     ['A' = 1,
      'B' = 0,
      'C' = 5,
      'D' = 1,
      'E' = 5,
      'F' = 1,
      'Ac' = 5,
      'Bd' = 0,
      'Ad' = 1,
      'Bc' = 0],
     [5 is 1 * 5, 0 is 0 * 1, 5 is 5 - 0, 1 is 1 * 1, 0 is 0 * 5, 1 is 1 + 0]).
step(5 is 1 * 5, builtin, [], []).
step(5 is 5 - 0, builtin, [], []).
step(0 is 0 * 5, builtin, [], []).
step(c_add([5, 1], [-9, -5], [-4, -4]),
     rule(12),
     ['A' = 5, 'B' = 1, 'C' = -9, 'D' = -5, 'E' = -4, 'F' = -4],
     [-4 is 5 + -9, -4 is 1 + -5]).
step(-4 is 5 + -9, builtin, [], []).
step(poly_eval_acc([[14, 33], [24, -44], [-26, 0]], [5, 1], [-4, -4], [0, 0]),
     rule(18),
     ['Coeff' = [14, 33],
      'Rest' = [[24, -44], [-26, 0]],
      'X' = [5, 1],
      'Acc' = [-4, -4],
      'Value' = [0, 0],
      'Product' = [-16, -24],
      'Next' = [-2, 9]],
     [c_mul([-4, -4], [5, 1], [-16, -24]),
      c_add([-16, -24], [14, 33], [-2, 9]),
      poly_eval_acc([[24, -44], [-26, 0]], [5, 1], [-2, 9], [0, 0])]).
step(c_mul([-4, -4], [5, 1], [-16, -24]),
     rule(15),
     ['A' = -4,
      'B' = -4,
      'C' = 5,
      'D' = 1,
      'E' = -16,
      'F' = -24,
      'Ac' = -20,
      'Bd' = -4,
      'Ad' = -4,
      'Bc' = -20],
     [-20 is -4 * 5,
      -4 is -4 * 1,
      -16 is -20 - -4,
      -4 is -4 * 1,
      -20 is -4 * 5,
      -24 is -4 + -20]).
step(-20 is -4 * 5, builtin, [], []).
step(-16 is -20 - -4, builtin, [], []).
step(-24 is -4 + -20, builtin, [], []).
step(c_add([-16, -24], [14, 33], [-2, 9]),
     rule(12),
     ['A' = -16, 'B' = -24, 'C' = 14, 'D' = 33, 'E' = -2, 'F' = 9],
     [-2 is -16 + 14, 9 is -24 + 33]).
step(-2 is -16 + 14, builtin, [], []).
step(9 is -24 + 33, builtin, [], []).
step(poly_eval_acc([[24, -44], [-26, 0]], [5, 1], [-2, 9], [0, 0]),
     rule(18),
     ['Coeff' = [24, -44],
      'Rest' = [[-26, 0]],
      'X' = [5, 1],
      'Acc' = [-2, 9],
      'Value' = [0, 0],
      'Product' = [-19, 43],
      'Next' = [5, -1]],
     [c_mul([-2, 9], [5, 1], [-19, 43]),
      c_add([-19, 43], [24, -44], [5, -1]),
      poly_eval_acc([[-26, 0]], [5, 1], [5, -1], [0, 0])]).
step(c_mul([-2, 9], [5, 1], [-19, 43]),
     rule(15),
     ['A' = -2,
      'B' = 9,
      'C' = 5,
      'D' = 1,
      'E' = -19,
      'F' = 43,
      'Ac' = -10,
      'Bd' = 9,
      'Ad' = -2,
      'Bc' = 45],
     [-10 is -2 * 5, 9 is 9 * 1, -19 is -10 - 9, -2 is -2 * 1, 45 is 9 * 5, 43 is -2 + 45]).
step(-10 is -2 * 5, builtin, [], []).
step(9 is 9 * 1, builtin, [], []).
step(-19 is -10 - 9, builtin, [], []).
step(-2 is -2 * 1, builtin, [], []).
step(45 is 9 * 5, builtin, [], []).
step(43 is -2 + 45, builtin, [], []).
step(c_add([-19, 43], [24, -44], [5, -1]),
     rule(12),
     ['A' = -19, 'B' = 43, 'C' = 24, 'D' = -44, 'E' = 5, 'F' = -1],
     [5 is -19 + 24, -1 is 43 + -44]).
step(5 is -19 + 24, builtin, [], []).
step(-1 is 43 + -44, builtin, [], []).
step(poly_eval_acc([[-26, 0]], [5, 1], [5, -1], [0, 0]),
     rule(18),
     ['Coeff' = [-26, 0],
      'Rest' = [],
      'X' = [5, 1],
      'Acc' = [5, -1],
      'Value' = [0, 0],
      'Product' = [26, 0],
      'Next' = [0, 0]],
     [c_mul([5, -1], [5, 1], [26, 0]),
      c_add([26, 0], [-26, 0], [0, 0]),
      poly_eval_acc([], [5, 1], [0, 0], [0, 0])]).
step(c_mul([5, -1], [5, 1], [26, 0]),
     rule(15),
     ['A' = 5,
      'B' = -1,
      'C' = 5,
      'D' = 1,
      'E' = 26,
      'F' = 0,
      'Ac' = 25,
      'Bd' = -1,
      'Ad' = 5,
      'Bc' = -5],
     [25 is 5 * 5, -1 is -1 * 1, 26 is 25 - -1, 5 is 5 * 1, -5 is -1 * 5, 0 is 5 + -5]).
step(25 is 5 * 5, builtin, [], []).
step(-1 is -1 * 1, builtin, [], []).
step(26 is 25 - -1, builtin, [], []).
step(5 is 5 * 1, builtin, [], []).
step(-5 is -1 * 5, builtin, [], []).
step(0 is 5 + -5, builtin, [], []).
step(poly_eval_acc([], [5, 1], [0, 0], [0, 0]), fact(17), ['Acc' = [0, 0]], []).
step(reconstructedPolynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(30),
     ['Case' = real_quartic, 'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]],
     [reconstructed(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(reconstructed(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(29),
     ['Case' = real_quartic,
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Roots' = [[1, 0], [2, 0], [3, 0], [4, 0]]],
     [known_roots(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]),
      poly_from_roots([[1, 0], [2, 0], [3, 0], [4, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(known_roots(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]), fact(9), [], []).
step(poly_from_roots([[1, 0], [2, 0], [3, 0], [4, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(21),
     ['Roots' = [[1, 0], [2, 0], [3, 0], [4, 0]],
      'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]],
     [poly_from_roots_acc([[1, 0], [2, 0], [3, 0], [4, 0]], [[1, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_from_roots_acc([[1, 0], [2, 0], [3, 0], [4, 0]], [[1, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(23),
     ['Root' = [1, 0],
      'Rest' = [[2, 0], [3, 0], [4, 0]],
      'Coeffs' = [[1, 0]],
      'Result' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Next' = [[1, 0], [-1, 0]]],
     [poly_mul_linear([[1, 0]], [1, 0], [[1, 0], [-1, 0]]),
      poly_from_roots_acc([[2, 0], [3, 0], [4, 0]], [[1, 0], [-1, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_mul_linear([[1, 0]], [1, 0], [[1, 0], [-1, 0]]),
     rule(24),
     ['Coeffs' = [[1, 0]],
      'Root' = [1, 0],
      'Product' = [[1, 0], [-1, 0]],
      'Shifted' = [[1, 0], [0, 0]],
      'Minusroot' = [-1, 0],
      'Scaled' = [[-1, 0]],
      'Lower' = [[0, 0], [-1, 0]]],
     [append([[1, 0]], [[0, 0]], [[1, 0], [0, 0]]),
      c_neg([1, 0], [-1, 0]),
      poly_scale([-1, 0], [[1, 0]], [[-1, 0]]),
      append([[0, 0]], [[-1, 0]], [[0, 0], [-1, 0]]),
      poly_add([[1, 0], [0, 0]], [[0, 0], [-1, 0]], [[1, 0], [-1, 0]])]).
step(append([[1, 0]], [[0, 0]], [[1, 0], [0, 0]]), builtin, [], []).
step(c_neg([1, 0], [-1, 0]),
     rule(14),
     ['A' = 1, 'B' = 0, 'C' = -1, 'D' = 0],
     [-1 is - (1), 0 is - (0)]).
step(-1 is - (1), builtin, [], []).
step(0 is - (0), builtin, [], []).
step(poly_scale([-1, 0], [[1, 0]], [[-1, 0]]),
     rule(26),
     ['Factor' = [-1, 0], 'Coeff' = [1, 0], 'Rest' = [], 'Product' = [-1, 0], 'Scaled' = []],
     [c_mul([-1, 0], [1, 0], [-1, 0]), poly_scale([-1, 0], [], [])]).
step(c_mul([-1, 0], [1, 0], [-1, 0]),
     rule(15),
     ['A' = -1,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -1,
      'F' = 0,
      'Ac' = -1,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-1 is -1 * 1, 0 is 0 * 0, -1 is -1 - 0, 0 is -1 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-1 is -1 - 0, builtin, [], []).
step(0 is -1 * 0, builtin, [], []).
step(poly_scale([-1, 0], [], []), fact(25), [], []).
step(append([[0, 0]], [[-1, 0]], [[0, 0], [-1, 0]]), builtin, [], []).
step(poly_add([[1, 0], [0, 0]], [[0, 0], [-1, 0]], [[1, 0], [-1, 0]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[0, 0]],
      'B' = [0, 0],
      'Bs' = [[-1, 0]],
      'C' = [1, 0],
      'Cs' = [[-1, 0]]],
     [c_add([1, 0], [0, 0], [1, 0]), poly_add([[0, 0]], [[-1, 0]], [[-1, 0]])]).
step(c_add([1, 0], [0, 0], [1, 0]),
     rule(12),
     ['A' = 1, 'B' = 0, 'C' = 0, 'D' = 0, 'E' = 1, 'F' = 0],
     [1 is 1 + 0, 0 is 0 + 0]).
step(poly_add([[0, 0]], [[-1, 0]], [[-1, 0]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [-1, 0], 'Bs' = [], 'C' = [-1, 0], 'Cs' = []],
     [c_add([0, 0], [-1, 0], [-1, 0]), poly_add([], [], [])]).
step(c_add([0, 0], [-1, 0], [-1, 0]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = -1, 'D' = 0, 'E' = -1, 'F' = 0],
     [-1 is 0 + -1, 0 is 0 + 0]).
step(-1 is 0 + -1, builtin, [], []).
step(poly_add([], [], []), fact(27), [], []).
step(poly_from_roots_acc([[2, 0], [3, 0], [4, 0]], [[1, 0], [-1, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(23),
     ['Root' = [2, 0],
      'Rest' = [[3, 0], [4, 0]],
      'Coeffs' = [[1, 0], [-1, 0]],
      'Result' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Next' = [[1, 0], [-3, 0], [2, 0]]],
     [poly_mul_linear([[1, 0], [-1, 0]], [2, 0], [[1, 0], [-3, 0], [2, 0]]),
      poly_from_roots_acc([[3, 0], [4, 0]], [[1, 0], [-3, 0], [2, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_mul_linear([[1, 0], [-1, 0]], [2, 0], [[1, 0], [-3, 0], [2, 0]]),
     rule(24),
     ['Coeffs' = [[1, 0], [-1, 0]],
      'Root' = [2, 0],
      'Product' = [[1, 0], [-3, 0], [2, 0]],
      'Shifted' = [[1, 0], [-1, 0], [0, 0]],
      'Minusroot' = [-2, 0],
      'Scaled' = [[-2, 0], [2, 0]],
      'Lower' = [[0, 0], [-2, 0], [2, 0]]],
     [append([[1, 0], [-1, 0]], [[0, 0]], [[1, 0], [-1, 0], [0, 0]]),
      c_neg([2, 0], [-2, 0]),
      poly_scale([-2, 0], [[1, 0], [-1, 0]], [[-2, 0], [2, 0]]),
      append([[0, 0]], [[-2, 0], [2, 0]], [[0, 0], [-2, 0], [2, 0]]),
      poly_add([[1, 0], [-1, 0], [0, 0]], [[0, 0], [-2, 0], [2, 0]], [[1, 0], [-3, 0], [2, 0]])]).
step(append([[1, 0], [-1, 0]], [[0, 0]], [[1, 0], [-1, 0], [0, 0]]), builtin, [], []).
step(c_neg([2, 0], [-2, 0]),
     rule(14),
     ['A' = 2, 'B' = 0, 'C' = -2, 'D' = 0],
     [-2 is - (2), 0 is - (0)]).
step(-2 is - (2), builtin, [], []).
step(poly_scale([-2, 0], [[1, 0], [-1, 0]], [[-2, 0], [2, 0]]),
     rule(26),
     ['Factor' = [-2, 0],
      'Coeff' = [1, 0],
      'Rest' = [[-1, 0]],
      'Product' = [-2, 0],
      'Scaled' = [[2, 0]]],
     [c_mul([-2, 0], [1, 0], [-2, 0]), poly_scale([-2, 0], [[-1, 0]], [[2, 0]])]).
step(c_mul([-2, 0], [1, 0], [-2, 0]),
     rule(15),
     ['A' = -2,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -2,
      'F' = 0,
      'Ac' = -2,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-2 is -2 * 1, 0 is 0 * 0, -2 is -2 - 0, 0 is -2 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-2 is -2 - 0, builtin, [], []).
step(0 is -2 * 0, builtin, [], []).
step(poly_scale([-2, 0], [[-1, 0]], [[2, 0]]),
     rule(26),
     ['Factor' = [-2, 0], 'Coeff' = [-1, 0], 'Rest' = [], 'Product' = [2, 0], 'Scaled' = []],
     [c_mul([-2, 0], [-1, 0], [2, 0]), poly_scale([-2, 0], [], [])]).
step(c_mul([-2, 0], [-1, 0], [2, 0]),
     rule(15),
     ['A' = -2,
      'B' = 0,
      'C' = -1,
      'D' = 0,
      'E' = 2,
      'F' = 0,
      'Ac' = 2,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [2 is -2 * -1, 0 is 0 * 0, 2 is 2 - 0, 0 is -2 * 0, 0 is 0 * -1, 0 is 0 + 0]).
step(2 is -2 * -1, builtin, [], []).
step(0 is 0 * -1, builtin, [], []).
step(poly_scale([-2, 0], [], []), fact(25), [], []).
step(append([[0, 0]], [[-2, 0], [2, 0]], [[0, 0], [-2, 0], [2, 0]]), builtin, [], []).
step(poly_add([[1, 0], [-1, 0], [0, 0]], [[0, 0], [-2, 0], [2, 0]], [[1, 0], [-3, 0], [2, 0]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[-1, 0], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-2, 0], [2, 0]],
      'C' = [1, 0],
      'Cs' = [[-3, 0], [2, 0]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[-1, 0], [0, 0]], [[-2, 0], [2, 0]], [[-3, 0], [2, 0]])]).
step(poly_add([[-1, 0], [0, 0]], [[-2, 0], [2, 0]], [[-3, 0], [2, 0]]),
     rule(28),
     ['A' = [-1, 0],
      'As' = [[0, 0]],
      'B' = [-2, 0],
      'Bs' = [[2, 0]],
      'C' = [-3, 0],
      'Cs' = [[2, 0]]],
     [c_add([-1, 0], [-2, 0], [-3, 0]), poly_add([[0, 0]], [[2, 0]], [[2, 0]])]).
step(c_add([-1, 0], [-2, 0], [-3, 0]),
     rule(12),
     ['A' = -1, 'B' = 0, 'C' = -2, 'D' = 0, 'E' = -3, 'F' = 0],
     [-3 is -1 + -2, 0 is 0 + 0]).
step(-3 is -1 + -2, builtin, [], []).
step(poly_add([[0, 0]], [[2, 0]], [[2, 0]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [2, 0], 'Bs' = [], 'C' = [2, 0], 'Cs' = []],
     [c_add([0, 0], [2, 0], [2, 0]), poly_add([], [], [])]).
step(c_add([0, 0], [2, 0], [2, 0]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = 2, 'D' = 0, 'E' = 2, 'F' = 0],
     [2 is 0 + 2, 0 is 0 + 0]).
step(2 is 0 + 2, builtin, [], []).
step(poly_from_roots_acc([[3, 0], [4, 0]], [[1, 0], [-3, 0], [2, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(23),
     ['Root' = [3, 0],
      'Rest' = [[4, 0]],
      'Coeffs' = [[1, 0], [-3, 0], [2, 0]],
      'Result' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Next' = [[1, 0], [-6, 0], [11, 0], [-6, 0]]],
     [poly_mul_linear([[1, 0], [-3, 0], [2, 0]], [3, 0], [[1, 0], [-6, 0], [11, 0], [-6, 0]]),
      poly_from_roots_acc([[4, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_mul_linear([[1, 0], [-3, 0], [2, 0]], [3, 0], [[1, 0], [-6, 0], [11, 0], [-6, 0]]),
     rule(24),
     ['Coeffs' = [[1, 0], [-3, 0], [2, 0]],
      'Root' = [3, 0],
      'Product' = [[1, 0], [-6, 0], [11, 0], [-6, 0]],
      'Shifted' = [[1, 0], [-3, 0], [2, 0], [0, 0]],
      'Minusroot' = [-3, 0],
      'Scaled' = [[-3, 0], [9, 0], [-6, 0]],
      'Lower' = [[0, 0], [-3, 0], [9, 0], [-6, 0]]],
     [append([[1, 0], [-3, 0], [2, 0]], [[0, 0]], [[1, 0], [-3, 0], [2, 0], [0, 0]]),
      c_neg([3, 0], [-3, 0]),
      poly_scale([-3, 0], [[1, 0], [-3, 0], [2, 0]], [[-3, 0], [9, 0], [-6, 0]]),
      append([[0, 0]], [[-3, 0], [9, 0], [-6, 0]], [[0, 0], [-3, 0], [9, 0], [-6, 0]]),
      poly_add([[1, 0], [-3, 0], [2, 0], [0, 0]], [[0, 0], [-3, 0], [9, 0], [-6, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0]])]).
step(append([[1, 0], [-3, 0], [2, 0]], [[0, 0]], [[1, 0], [-3, 0], [2, 0], [0, 0]]),
     builtin,
     [],
     []).
step(c_neg([3, 0], [-3, 0]),
     rule(14),
     ['A' = 3, 'B' = 0, 'C' = -3, 'D' = 0],
     [-3 is - (3), 0 is - (0)]).
step(-3 is - (3), builtin, [], []).
step(poly_scale([-3, 0], [[1, 0], [-3, 0], [2, 0]], [[-3, 0], [9, 0], [-6, 0]]),
     rule(26),
     ['Factor' = [-3, 0],
      'Coeff' = [1, 0],
      'Rest' = [[-3, 0], [2, 0]],
      'Product' = [-3, 0],
      'Scaled' = [[9, 0], [-6, 0]]],
     [c_mul([-3, 0], [1, 0], [-3, 0]),
      poly_scale([-3, 0], [[-3, 0], [2, 0]], [[9, 0], [-6, 0]])]).
step(c_mul([-3, 0], [1, 0], [-3, 0]),
     rule(15),
     ['A' = -3,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -3,
      'F' = 0,
      'Ac' = -3,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-3 is -3 * 1, 0 is 0 * 0, -3 is -3 - 0, 0 is -3 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-3 is -3 * 1, builtin, [], []).
step(-3 is -3 - 0, builtin, [], []).
step(0 is -3 * 0, builtin, [], []).
step(poly_scale([-3, 0], [[-3, 0], [2, 0]], [[9, 0], [-6, 0]]),
     rule(26),
     ['Factor' = [-3, 0],
      'Coeff' = [-3, 0],
      'Rest' = [[2, 0]],
      'Product' = [9, 0],
      'Scaled' = [[-6, 0]]],
     [c_mul([-3, 0], [-3, 0], [9, 0]), poly_scale([-3, 0], [[2, 0]], [[-6, 0]])]).
step(c_mul([-3, 0], [-3, 0], [9, 0]),
     rule(15),
     ['A' = -3,
      'B' = 0,
      'C' = -3,
      'D' = 0,
      'E' = 9,
      'F' = 0,
      'Ac' = 9,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [9 is -3 * -3, 0 is 0 * 0, 9 is 9 - 0, 0 is -3 * 0, 0 is 0 * -3, 0 is 0 + 0]).
step(9 is -3 * -3, builtin, [], []).
step(9 is 9 - 0, builtin, [], []).
step(0 is 0 * -3, builtin, [], []).
step(poly_scale([-3, 0], [[2, 0]], [[-6, 0]]),
     rule(26),
     ['Factor' = [-3, 0], 'Coeff' = [2, 0], 'Rest' = [], 'Product' = [-6, 0], 'Scaled' = []],
     [c_mul([-3, 0], [2, 0], [-6, 0]), poly_scale([-3, 0], [], [])]).
step(c_mul([-3, 0], [2, 0], [-6, 0]),
     rule(15),
     ['A' = -3,
      'B' = 0,
      'C' = 2,
      'D' = 0,
      'E' = -6,
      'F' = 0,
      'Ac' = -6,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-6 is -3 * 2, 0 is 0 * 0, -6 is -6 - 0, 0 is -3 * 0, 0 is 0 * 2, 0 is 0 + 0]).
step(-6 is -6 - 0, builtin, [], []).
step(poly_scale([-3, 0], [], []), fact(25), [], []).
step(append([[0, 0]], [[-3, 0], [9, 0], [-6, 0]], [[0, 0], [-3, 0], [9, 0], [-6, 0]]),
     builtin,
     [],
     []).
step(poly_add([[1, 0], [-3, 0], [2, 0], [0, 0]], [[0, 0], [-3, 0], [9, 0], [-6, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[-3, 0], [2, 0], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-3, 0], [9, 0], [-6, 0]],
      'C' = [1, 0],
      'Cs' = [[-6, 0], [11, 0], [-6, 0]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[-3, 0], [2, 0], [0, 0]], [[-3, 0], [9, 0], [-6, 0]], [[-6, 0], [11, 0], [-6, 0]])]).
step(poly_add([[-3, 0], [2, 0], [0, 0]], [[-3, 0], [9, 0], [-6, 0]], [[-6, 0], [11, 0], [-6, 0]]),
     rule(28),
     ['A' = [-3, 0],
      'As' = [[2, 0], [0, 0]],
      'B' = [-3, 0],
      'Bs' = [[9, 0], [-6, 0]],
      'C' = [-6, 0],
      'Cs' = [[11, 0], [-6, 0]]],
     [c_add([-3, 0], [-3, 0], [-6, 0]),
      poly_add([[2, 0], [0, 0]], [[9, 0], [-6, 0]], [[11, 0], [-6, 0]])]).
step(c_add([-3, 0], [-3, 0], [-6, 0]),
     rule(12),
     ['A' = -3, 'B' = 0, 'C' = -3, 'D' = 0, 'E' = -6, 'F' = 0],
     [-6 is -3 + -3, 0 is 0 + 0]).
step(-6 is -3 + -3, builtin, [], []).
step(poly_add([[2, 0], [0, 0]], [[9, 0], [-6, 0]], [[11, 0], [-6, 0]]),
     rule(28),
     ['A' = [2, 0],
      'As' = [[0, 0]],
      'B' = [9, 0],
      'Bs' = [[-6, 0]],
      'C' = [11, 0],
      'Cs' = [[-6, 0]]],
     [c_add([2, 0], [9, 0], [11, 0]), poly_add([[0, 0]], [[-6, 0]], [[-6, 0]])]).
step(c_add([2, 0], [9, 0], [11, 0]),
     rule(12),
     ['A' = 2, 'B' = 0, 'C' = 9, 'D' = 0, 'E' = 11, 'F' = 0],
     [11 is 2 + 9, 0 is 0 + 0]).
step(11 is 2 + 9, builtin, [], []).
step(poly_add([[0, 0]], [[-6, 0]], [[-6, 0]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [-6, 0], 'Bs' = [], 'C' = [-6, 0], 'Cs' = []],
     [c_add([0, 0], [-6, 0], [-6, 0]), poly_add([], [], [])]).
step(c_add([0, 0], [-6, 0], [-6, 0]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = -6, 'D' = 0, 'E' = -6, 'F' = 0],
     [-6 is 0 + -6, 0 is 0 + 0]).
step(-6 is 0 + -6, builtin, [], []).
step(poly_from_roots_acc([[4, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(23),
     ['Root' = [4, 0],
      'Rest' = [],
      'Coeffs' = [[1, 0], [-6, 0], [11, 0], [-6, 0]],
      'Result' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Next' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]],
     [poly_mul_linear([[1, 0], [-6, 0], [11, 0], [-6, 0]], [4, 0], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      poly_from_roots_acc([], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_mul_linear([[1, 0], [-6, 0], [11, 0], [-6, 0]], [4, 0], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(24),
     ['Coeffs' = [[1, 0], [-6, 0], [11, 0], [-6, 0]],
      'Root' = [4, 0],
      'Product' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]],
      'Shifted' = [[1, 0], [-6, 0], [11, 0], [-6, 0], [0, 0]],
      'Minusroot' = [-4, 0],
      'Scaled' = [[-4, 0], [24, 0], [-44, 0], [24, 0]],
      'Lower' = [[0, 0], [-4, 0], [24, 0], [-44, 0], [24, 0]]],
     [append([[1, 0], [-6, 0], [11, 0], [-6, 0]], [[0, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0], [0, 0]]),
      c_neg([4, 0], [-4, 0]),
      poly_scale([-4, 0], [[1, 0], [-6, 0], [11, 0], [-6, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]]),
      append([[0, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]], [[0, 0], [-4, 0], [24, 0], [-44, 0], [24, 0]]),
      poly_add([[1, 0], [-6, 0], [11, 0], [-6, 0], [0, 0]], [[0, 0], [-4, 0], [24, 0], [-44, 0], [24, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(append([[1, 0], [-6, 0], [11, 0], [-6, 0]], [[0, 0]], [[1, 0], [-6, 0], [11, 0], [-6, 0], [0, 0]]),
     builtin,
     [],
     []).
step(c_neg([4, 0], [-4, 0]),
     rule(14),
     ['A' = 4, 'B' = 0, 'C' = -4, 'D' = 0],
     [-4 is - (4), 0 is - (0)]).
step(-4 is - (4), builtin, [], []).
step(poly_scale([-4, 0], [[1, 0], [-6, 0], [11, 0], [-6, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]]),
     rule(26),
     ['Factor' = [-4, 0],
      'Coeff' = [1, 0],
      'Rest' = [[-6, 0], [11, 0], [-6, 0]],
      'Product' = [-4, 0],
      'Scaled' = [[24, 0], [-44, 0], [24, 0]]],
     [c_mul([-4, 0], [1, 0], [-4, 0]),
      poly_scale([-4, 0], [[-6, 0], [11, 0], [-6, 0]], [[24, 0], [-44, 0], [24, 0]])]).
step(c_mul([-4, 0], [1, 0], [-4, 0]),
     rule(15),
     ['A' = -4,
      'B' = 0,
      'C' = 1,
      'D' = 0,
      'E' = -4,
      'F' = 0,
      'Ac' = -4,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-4 is -4 * 1, 0 is 0 * 0, -4 is -4 - 0, 0 is -4 * 0, 0 is 0 * 1, 0 is 0 + 0]).
step(-4 is -4 - 0, builtin, [], []).
step(poly_scale([-4, 0], [[-6, 0], [11, 0], [-6, 0]], [[24, 0], [-44, 0], [24, 0]]),
     rule(26),
     ['Factor' = [-4, 0],
      'Coeff' = [-6, 0],
      'Rest' = [[11, 0], [-6, 0]],
      'Product' = [24, 0],
      'Scaled' = [[-44, 0], [24, 0]]],
     [c_mul([-4, 0], [-6, 0], [24, 0]),
      poly_scale([-4, 0], [[11, 0], [-6, 0]], [[-44, 0], [24, 0]])]).
step(c_mul([-4, 0], [-6, 0], [24, 0]),
     rule(15),
     ['A' = -4,
      'B' = 0,
      'C' = -6,
      'D' = 0,
      'E' = 24,
      'F' = 0,
      'Ac' = 24,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [24 is -4 * -6, 0 is 0 * 0, 24 is 24 - 0, 0 is -4 * 0, 0 is 0 * -6, 0 is 0 + 0]).
step(24 is -4 * -6, builtin, [], []).
step(24 is 24 - 0, builtin, [], []).
step(0 is 0 * -6, builtin, [], []).
step(poly_scale([-4, 0], [[11, 0], [-6, 0]], [[-44, 0], [24, 0]]),
     rule(26),
     ['Factor' = [-4, 0],
      'Coeff' = [11, 0],
      'Rest' = [[-6, 0]],
      'Product' = [-44, 0],
      'Scaled' = [[24, 0]]],
     [c_mul([-4, 0], [11, 0], [-44, 0]), poly_scale([-4, 0], [[-6, 0]], [[24, 0]])]).
step(c_mul([-4, 0], [11, 0], [-44, 0]),
     rule(15),
     ['A' = -4,
      'B' = 0,
      'C' = 11,
      'D' = 0,
      'E' = -44,
      'F' = 0,
      'Ac' = -44,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = 0],
     [-44 is -4 * 11, 0 is 0 * 0, -44 is -44 - 0, 0 is -4 * 0, 0 is 0 * 11, 0 is 0 + 0]).
step(-44 is -4 * 11, builtin, [], []).
step(-44 is -44 - 0, builtin, [], []).
step(0 is 0 * 11, builtin, [], []).
step(poly_scale([-4, 0], [[-6, 0]], [[24, 0]]),
     rule(26),
     ['Factor' = [-4, 0], 'Coeff' = [-6, 0], 'Rest' = [], 'Product' = [24, 0], 'Scaled' = []],
     [c_mul([-4, 0], [-6, 0], [24, 0]), poly_scale([-4, 0], [], [])]).
step(poly_scale([-4, 0], [], []), fact(25), [], []).
step(append([[0, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]], [[0, 0], [-4, 0], [24, 0], [-44, 0], [24, 0]]),
     builtin,
     [],
     []).
step(poly_add([[1, 0], [-6, 0], [11, 0], [-6, 0], [0, 0]], [[0, 0], [-4, 0], [24, 0], [-44, 0], [24, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[-6, 0], [11, 0], [-6, 0], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-4, 0], [24, 0], [-44, 0], [24, 0]],
      'C' = [1, 0],
      'Cs' = [[-10, 0], [35, 0], [-50, 0], [24, 0]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[-6, 0], [11, 0], [-6, 0], [0, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]], [[-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(poly_add([[-6, 0], [11, 0], [-6, 0], [0, 0]], [[-4, 0], [24, 0], [-44, 0], [24, 0]], [[-10, 0], [35, 0], [-50, 0], [24, 0]]),
     rule(28),
     ['A' = [-6, 0],
      'As' = [[11, 0], [-6, 0], [0, 0]],
      'B' = [-4, 0],
      'Bs' = [[24, 0], [-44, 0], [24, 0]],
      'C' = [-10, 0],
      'Cs' = [[35, 0], [-50, 0], [24, 0]]],
     [c_add([-6, 0], [-4, 0], [-10, 0]),
      poly_add([[11, 0], [-6, 0], [0, 0]], [[24, 0], [-44, 0], [24, 0]], [[35, 0], [-50, 0], [24, 0]])]).
step(c_add([-6, 0], [-4, 0], [-10, 0]),
     rule(12),
     ['A' = -6, 'B' = 0, 'C' = -4, 'D' = 0, 'E' = -10, 'F' = 0],
     [-10 is -6 + -4, 0 is 0 + 0]).
step(-10 is -6 + -4, builtin, [], []).
step(poly_add([[11, 0], [-6, 0], [0, 0]], [[24, 0], [-44, 0], [24, 0]], [[35, 0], [-50, 0], [24, 0]]),
     rule(28),
     ['A' = [11, 0],
      'As' = [[-6, 0], [0, 0]],
      'B' = [24, 0],
      'Bs' = [[-44, 0], [24, 0]],
      'C' = [35, 0],
      'Cs' = [[-50, 0], [24, 0]]],
     [c_add([11, 0], [24, 0], [35, 0]),
      poly_add([[-6, 0], [0, 0]], [[-44, 0], [24, 0]], [[-50, 0], [24, 0]])]).
step(c_add([11, 0], [24, 0], [35, 0]),
     rule(12),
     ['A' = 11, 'B' = 0, 'C' = 24, 'D' = 0, 'E' = 35, 'F' = 0],
     [35 is 11 + 24, 0 is 0 + 0]).
step(35 is 11 + 24, builtin, [], []).
step(poly_add([[-6, 0], [0, 0]], [[-44, 0], [24, 0]], [[-50, 0], [24, 0]]),
     rule(28),
     ['A' = [-6, 0],
      'As' = [[0, 0]],
      'B' = [-44, 0],
      'Bs' = [[24, 0]],
      'C' = [-50, 0],
      'Cs' = [[24, 0]]],
     [c_add([-6, 0], [-44, 0], [-50, 0]), poly_add([[0, 0]], [[24, 0]], [[24, 0]])]).
step(c_add([-6, 0], [-44, 0], [-50, 0]),
     rule(12),
     ['A' = -6, 'B' = 0, 'C' = -44, 'D' = 0, 'E' = -50, 'F' = 0],
     [-50 is -6 + -44, 0 is 0 + 0]).
step(-50 is -6 + -44, builtin, [], []).
step(poly_add([[0, 0]], [[24, 0]], [[24, 0]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [24, 0], 'Bs' = [], 'C' = [24, 0], 'Cs' = []],
     [c_add([0, 0], [24, 0], [24, 0]), poly_add([], [], [])]).
step(c_add([0, 0], [24, 0], [24, 0]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = 24, 'D' = 0, 'E' = 24, 'F' = 0],
     [24 is 0 + 24, 0 is 0 + 0]).
step(24 is 0 + 24, builtin, [], []).
step(poly_from_roots_acc([], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]], [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
     fact(22),
     ['Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]],
     []).
step(reconstructedPolynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(30),
     ['Case' = complex_quartic, 'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]],
     [reconstructed(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(reconstructed(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(29),
     ['Case' = complex_quartic,
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Roots' = [[0, 1], [1, 1], [3, 2], [5, 1]]],
     [known_roots(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]),
      poly_from_roots([[0, 1], [1, 1], [3, 2], [5, 1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(known_roots(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]), fact(10), [], []).
step(poly_from_roots([[0, 1], [1, 1], [3, 2], [5, 1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(21),
     ['Roots' = [[0, 1], [1, 1], [3, 2], [5, 1]],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]],
     [poly_from_roots_acc([[0, 1], [1, 1], [3, 2], [5, 1]], [[1, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_from_roots_acc([[0, 1], [1, 1], [3, 2], [5, 1]], [[1, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(23),
     ['Root' = [0, 1],
      'Rest' = [[1, 1], [3, 2], [5, 1]],
      'Coeffs' = [[1, 0]],
      'Result' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Next' = [[1, 0], [0, -1]]],
     [poly_mul_linear([[1, 0]], [0, 1], [[1, 0], [0, -1]]),
      poly_from_roots_acc([[1, 1], [3, 2], [5, 1]], [[1, 0], [0, -1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_mul_linear([[1, 0]], [0, 1], [[1, 0], [0, -1]]),
     rule(24),
     ['Coeffs' = [[1, 0]],
      'Root' = [0, 1],
      'Product' = [[1, 0], [0, -1]],
      'Shifted' = [[1, 0], [0, 0]],
      'Minusroot' = [0, -1],
      'Scaled' = [[0, -1]],
      'Lower' = [[0, 0], [0, -1]]],
     [append([[1, 0]], [[0, 0]], [[1, 0], [0, 0]]),
      c_neg([0, 1], [0, -1]),
      poly_scale([0, -1], [[1, 0]], [[0, -1]]),
      append([[0, 0]], [[0, -1]], [[0, 0], [0, -1]]),
      poly_add([[1, 0], [0, 0]], [[0, 0], [0, -1]], [[1, 0], [0, -1]])]).
step(c_neg([0, 1], [0, -1]),
     rule(14),
     ['A' = 0, 'B' = 1, 'C' = 0, 'D' = -1],
     [0 is - (0), -1 is - (1)]).
step(poly_scale([0, -1], [[1, 0]], [[0, -1]]),
     rule(26),
     ['Factor' = [0, -1], 'Coeff' = [1, 0], 'Rest' = [], 'Product' = [0, -1], 'Scaled' = []],
     [c_mul([0, -1], [1, 0], [0, -1]), poly_scale([0, -1], [], [])]).
step(c_mul([0, -1], [1, 0], [0, -1]),
     rule(15),
     ['A' = 0,
      'B' = -1,
      'C' = 1,
      'D' = 0,
      'E' = 0,
      'F' = -1,
      'Ac' = 0,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = -1],
     [0 is 0 * 1, 0 is -1 * 0, 0 is 0 - 0, 0 is 0 * 0, -1 is -1 * 1, -1 is 0 + -1]).
step(poly_scale([0, -1], [], []), fact(25), [], []).
step(append([[0, 0]], [[0, -1]], [[0, 0], [0, -1]]), builtin, [], []).
step(poly_add([[1, 0], [0, 0]], [[0, 0], [0, -1]], [[1, 0], [0, -1]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[0, 0]],
      'B' = [0, 0],
      'Bs' = [[0, -1]],
      'C' = [1, 0],
      'Cs' = [[0, -1]]],
     [c_add([1, 0], [0, 0], [1, 0]), poly_add([[0, 0]], [[0, -1]], [[0, -1]])]).
step(poly_add([[0, 0]], [[0, -1]], [[0, -1]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [0, -1], 'Bs' = [], 'C' = [0, -1], 'Cs' = []],
     [c_add([0, 0], [0, -1], [0, -1]), poly_add([], [], [])]).
step(c_add([0, 0], [0, -1], [0, -1]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = 0, 'D' = -1, 'E' = 0, 'F' = -1],
     [0 is 0 + 0, -1 is 0 + -1]).
step(poly_from_roots_acc([[1, 1], [3, 2], [5, 1]], [[1, 0], [0, -1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(23),
     ['Root' = [1, 1],
      'Rest' = [[3, 2], [5, 1]],
      'Coeffs' = [[1, 0], [0, -1]],
      'Result' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Next' = [[1, 0], [-1, -2], [-1, 1]]],
     [poly_mul_linear([[1, 0], [0, -1]], [1, 1], [[1, 0], [-1, -2], [-1, 1]]),
      poly_from_roots_acc([[3, 2], [5, 1]], [[1, 0], [-1, -2], [-1, 1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_mul_linear([[1, 0], [0, -1]], [1, 1], [[1, 0], [-1, -2], [-1, 1]]),
     rule(24),
     ['Coeffs' = [[1, 0], [0, -1]],
      'Root' = [1, 1],
      'Product' = [[1, 0], [-1, -2], [-1, 1]],
      'Shifted' = [[1, 0], [0, -1], [0, 0]],
      'Minusroot' = [-1, -1],
      'Scaled' = [[-1, -1], [-1, 1]],
      'Lower' = [[0, 0], [-1, -1], [-1, 1]]],
     [append([[1, 0], [0, -1]], [[0, 0]], [[1, 0], [0, -1], [0, 0]]),
      c_neg([1, 1], [-1, -1]),
      poly_scale([-1, -1], [[1, 0], [0, -1]], [[-1, -1], [-1, 1]]),
      append([[0, 0]], [[-1, -1], [-1, 1]], [[0, 0], [-1, -1], [-1, 1]]),
      poly_add([[1, 0], [0, -1], [0, 0]], [[0, 0], [-1, -1], [-1, 1]], [[1, 0], [-1, -2], [-1, 1]])]).
step(append([[1, 0], [0, -1]], [[0, 0]], [[1, 0], [0, -1], [0, 0]]), builtin, [], []).
step(c_neg([1, 1], [-1, -1]),
     rule(14),
     ['A' = 1, 'B' = 1, 'C' = -1, 'D' = -1],
     [-1 is - (1), -1 is - (1)]).
step(poly_scale([-1, -1], [[1, 0], [0, -1]], [[-1, -1], [-1, 1]]),
     rule(26),
     ['Factor' = [-1, -1],
      'Coeff' = [1, 0],
      'Rest' = [[0, -1]],
      'Product' = [-1, -1],
      'Scaled' = [[-1, 1]]],
     [c_mul([-1, -1], [1, 0], [-1, -1]), poly_scale([-1, -1], [[0, -1]], [[-1, 1]])]).
step(c_mul([-1, -1], [1, 0], [-1, -1]),
     rule(15),
     ['A' = -1,
      'B' = -1,
      'C' = 1,
      'D' = 0,
      'E' = -1,
      'F' = -1,
      'Ac' = -1,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = -1],
     [-1 is -1 * 1, 0 is -1 * 0, -1 is -1 - 0, 0 is -1 * 0, -1 is -1 * 1, -1 is 0 + -1]).
step(poly_scale([-1, -1], [[0, -1]], [[-1, 1]]),
     rule(26),
     ['Factor' = [-1, -1], 'Coeff' = [0, -1], 'Rest' = [], 'Product' = [-1, 1], 'Scaled' = []],
     [c_mul([-1, -1], [0, -1], [-1, 1]), poly_scale([-1, -1], [], [])]).
step(c_mul([-1, -1], [0, -1], [-1, 1]),
     rule(15),
     ['A' = -1,
      'B' = -1,
      'C' = 0,
      'D' = -1,
      'E' = -1,
      'F' = 1,
      'Ac' = 0,
      'Bd' = 1,
      'Ad' = 1,
      'Bc' = 0],
     [0 is -1 * 0, 1 is -1 * -1, -1 is 0 - 1, 1 is -1 * -1, 0 is -1 * 0, 1 is 1 + 0]).
step(1 is -1 * -1, builtin, [], []).
step(-1 is 0 - 1, builtin, [], []).
step(poly_scale([-1, -1], [], []), fact(25), [], []).
step(append([[0, 0]], [[-1, -1], [-1, 1]], [[0, 0], [-1, -1], [-1, 1]]), builtin, [], []).
step(poly_add([[1, 0], [0, -1], [0, 0]], [[0, 0], [-1, -1], [-1, 1]], [[1, 0], [-1, -2], [-1, 1]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[0, -1], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-1, -1], [-1, 1]],
      'C' = [1, 0],
      'Cs' = [[-1, -2], [-1, 1]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[0, -1], [0, 0]], [[-1, -1], [-1, 1]], [[-1, -2], [-1, 1]])]).
step(poly_add([[0, -1], [0, 0]], [[-1, -1], [-1, 1]], [[-1, -2], [-1, 1]]),
     rule(28),
     ['A' = [0, -1],
      'As' = [[0, 0]],
      'B' = [-1, -1],
      'Bs' = [[-1, 1]],
      'C' = [-1, -2],
      'Cs' = [[-1, 1]]],
     [c_add([0, -1], [-1, -1], [-1, -2]), poly_add([[0, 0]], [[-1, 1]], [[-1, 1]])]).
step(c_add([0, -1], [-1, -1], [-1, -2]),
     rule(12),
     ['A' = 0, 'B' = -1, 'C' = -1, 'D' = -1, 'E' = -1, 'F' = -2],
     [-1 is 0 + -1, -2 is -1 + -1]).
step(-2 is -1 + -1, builtin, [], []).
step(poly_add([[0, 0]], [[-1, 1]], [[-1, 1]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [-1, 1], 'Bs' = [], 'C' = [-1, 1], 'Cs' = []],
     [c_add([0, 0], [-1, 1], [-1, 1]), poly_add([], [], [])]).
step(c_add([0, 0], [-1, 1], [-1, 1]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = -1, 'D' = 1, 'E' = -1, 'F' = 1],
     [-1 is 0 + -1, 1 is 0 + 1]).
step(1 is 0 + 1, builtin, [], []).
step(poly_from_roots_acc([[3, 2], [5, 1]], [[1, 0], [-1, -2], [-1, 1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(23),
     ['Root' = [3, 2],
      'Rest' = [[5, 1]],
      'Coeffs' = [[1, 0], [-1, -2], [-1, 1]],
      'Result' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Next' = [[1, 0], [-4, -4], [-2, 9], [5, -1]]],
     [poly_mul_linear([[1, 0], [-1, -2], [-1, 1]], [3, 2], [[1, 0], [-4, -4], [-2, 9], [5, -1]]),
      poly_from_roots_acc([[5, 1]], [[1, 0], [-4, -4], [-2, 9], [5, -1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_mul_linear([[1, 0], [-1, -2], [-1, 1]], [3, 2], [[1, 0], [-4, -4], [-2, 9], [5, -1]]),
     rule(24),
     ['Coeffs' = [[1, 0], [-1, -2], [-1, 1]],
      'Root' = [3, 2],
      'Product' = [[1, 0], [-4, -4], [-2, 9], [5, -1]],
      'Shifted' = [[1, 0], [-1, -2], [-1, 1], [0, 0]],
      'Minusroot' = [-3, -2],
      'Scaled' = [[-3, -2], [-1, 8], [5, -1]],
      'Lower' = [[0, 0], [-3, -2], [-1, 8], [5, -1]]],
     [append([[1, 0], [-1, -2], [-1, 1]], [[0, 0]], [[1, 0], [-1, -2], [-1, 1], [0, 0]]),
      c_neg([3, 2], [-3, -2]),
      poly_scale([-3, -2], [[1, 0], [-1, -2], [-1, 1]], [[-3, -2], [-1, 8], [5, -1]]),
      append([[0, 0]], [[-3, -2], [-1, 8], [5, -1]], [[0, 0], [-3, -2], [-1, 8], [5, -1]]),
      poly_add([[1, 0], [-1, -2], [-1, 1], [0, 0]], [[0, 0], [-3, -2], [-1, 8], [5, -1]], [[1, 0], [-4, -4], [-2, 9], [5, -1]])]).
step(append([[1, 0], [-1, -2], [-1, 1]], [[0, 0]], [[1, 0], [-1, -2], [-1, 1], [0, 0]]),
     builtin,
     [],
     []).
step(c_neg([3, 2], [-3, -2]),
     rule(14),
     ['A' = 3, 'B' = 2, 'C' = -3, 'D' = -2],
     [-3 is - (3), -2 is - (2)]).
step(poly_scale([-3, -2], [[1, 0], [-1, -2], [-1, 1]], [[-3, -2], [-1, 8], [5, -1]]),
     rule(26),
     ['Factor' = [-3, -2],
      'Coeff' = [1, 0],
      'Rest' = [[-1, -2], [-1, 1]],
      'Product' = [-3, -2],
      'Scaled' = [[-1, 8], [5, -1]]],
     [c_mul([-3, -2], [1, 0], [-3, -2]),
      poly_scale([-3, -2], [[-1, -2], [-1, 1]], [[-1, 8], [5, -1]])]).
step(c_mul([-3, -2], [1, 0], [-3, -2]),
     rule(15),
     ['A' = -3,
      'B' = -2,
      'C' = 1,
      'D' = 0,
      'E' = -3,
      'F' = -2,
      'Ac' = -3,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = -2],
     [-3 is -3 * 1, 0 is -2 * 0, -3 is -3 - 0, 0 is -3 * 0, -2 is -2 * 1, -2 is 0 + -2]).
step(-2 is 0 + -2, builtin, [], []).
step(poly_scale([-3, -2], [[-1, -2], [-1, 1]], [[-1, 8], [5, -1]]),
     rule(26),
     ['Factor' = [-3, -2],
      'Coeff' = [-1, -2],
      'Rest' = [[-1, 1]],
      'Product' = [-1, 8],
      'Scaled' = [[5, -1]]],
     [c_mul([-3, -2], [-1, -2], [-1, 8]), poly_scale([-3, -2], [[-1, 1]], [[5, -1]])]).
step(c_mul([-3, -2], [-1, -2], [-1, 8]),
     rule(15),
     ['A' = -3,
      'B' = -2,
      'C' = -1,
      'D' = -2,
      'E' = -1,
      'F' = 8,
      'Ac' = 3,
      'Bd' = 4,
      'Ad' = 6,
      'Bc' = 2],
     [3 is -3 * -1, 4 is -2 * -2, -1 is 3 - 4, 6 is -3 * -2, 2 is -2 * -1, 8 is 6 + 2]).
step(3 is -3 * -1, builtin, [], []).
step(4 is -2 * -2, builtin, [], []).
step(-1 is 3 - 4, builtin, [], []).
step(6 is -3 * -2, builtin, [], []).
step(8 is 6 + 2, builtin, [], []).
step(poly_scale([-3, -2], [[-1, 1]], [[5, -1]]),
     rule(26),
     ['Factor' = [-3, -2], 'Coeff' = [-1, 1], 'Rest' = [], 'Product' = [5, -1], 'Scaled' = []],
     [c_mul([-3, -2], [-1, 1], [5, -1]), poly_scale([-3, -2], [], [])]).
step(c_mul([-3, -2], [-1, 1], [5, -1]),
     rule(15),
     ['A' = -3,
      'B' = -2,
      'C' = -1,
      'D' = 1,
      'E' = 5,
      'F' = -1,
      'Ac' = 3,
      'Bd' = -2,
      'Ad' = -3,
      'Bc' = 2],
     [3 is -3 * -1, -2 is -2 * 1, 5 is 3 - -2, -3 is -3 * 1, 2 is -2 * -1, -1 is -3 + 2]).
step(5 is 3 - -2, builtin, [], []).
step(-1 is -3 + 2, builtin, [], []).
step(poly_scale([-3, -2], [], []), fact(25), [], []).
step(append([[0, 0]], [[-3, -2], [-1, 8], [5, -1]], [[0, 0], [-3, -2], [-1, 8], [5, -1]]),
     builtin,
     [],
     []).
step(poly_add([[1, 0], [-1, -2], [-1, 1], [0, 0]], [[0, 0], [-3, -2], [-1, 8], [5, -1]], [[1, 0], [-4, -4], [-2, 9], [5, -1]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[-1, -2], [-1, 1], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-3, -2], [-1, 8], [5, -1]],
      'C' = [1, 0],
      'Cs' = [[-4, -4], [-2, 9], [5, -1]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[-1, -2], [-1, 1], [0, 0]], [[-3, -2], [-1, 8], [5, -1]], [[-4, -4], [-2, 9], [5, -1]])]).
step(poly_add([[-1, -2], [-1, 1], [0, 0]], [[-3, -2], [-1, 8], [5, -1]], [[-4, -4], [-2, 9], [5, -1]]),
     rule(28),
     ['A' = [-1, -2],
      'As' = [[-1, 1], [0, 0]],
      'B' = [-3, -2],
      'Bs' = [[-1, 8], [5, -1]],
      'C' = [-4, -4],
      'Cs' = [[-2, 9], [5, -1]]],
     [c_add([-1, -2], [-3, -2], [-4, -4]),
      poly_add([[-1, 1], [0, 0]], [[-1, 8], [5, -1]], [[-2, 9], [5, -1]])]).
step(c_add([-1, -2], [-3, -2], [-4, -4]),
     rule(12),
     ['A' = -1, 'B' = -2, 'C' = -3, 'D' = -2, 'E' = -4, 'F' = -4],
     [-4 is -1 + -3, -4 is -2 + -2]).
step(-4 is -1 + -3, builtin, [], []).
step(-4 is -2 + -2, builtin, [], []).
step(poly_add([[-1, 1], [0, 0]], [[-1, 8], [5, -1]], [[-2, 9], [5, -1]]),
     rule(28),
     ['A' = [-1, 1],
      'As' = [[0, 0]],
      'B' = [-1, 8],
      'Bs' = [[5, -1]],
      'C' = [-2, 9],
      'Cs' = [[5, -1]]],
     [c_add([-1, 1], [-1, 8], [-2, 9]), poly_add([[0, 0]], [[5, -1]], [[5, -1]])]).
step(c_add([-1, 1], [-1, 8], [-2, 9]),
     rule(12),
     ['A' = -1, 'B' = 1, 'C' = -1, 'D' = 8, 'E' = -2, 'F' = 9],
     [-2 is -1 + -1, 9 is 1 + 8]).
step(9 is 1 + 8, builtin, [], []).
step(poly_add([[0, 0]], [[5, -1]], [[5, -1]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [5, -1], 'Bs' = [], 'C' = [5, -1], 'Cs' = []],
     [c_add([0, 0], [5, -1], [5, -1]), poly_add([], [], [])]).
step(c_add([0, 0], [5, -1], [5, -1]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = 5, 'D' = -1, 'E' = 5, 'F' = -1],
     [5 is 0 + 5, -1 is 0 + -1]).
step(5 is 0 + 5, builtin, [], []).
step(poly_from_roots_acc([[5, 1]], [[1, 0], [-4, -4], [-2, 9], [5, -1]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(23),
     ['Root' = [5, 1],
      'Rest' = [],
      'Coeffs' = [[1, 0], [-4, -4], [-2, 9], [5, -1]],
      'Result' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Next' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]],
     [poly_mul_linear([[1, 0], [-4, -4], [-2, 9], [5, -1]], [5, 1], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      poly_from_roots_acc([], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_mul_linear([[1, 0], [-4, -4], [-2, 9], [5, -1]], [5, 1], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(24),
     ['Coeffs' = [[1, 0], [-4, -4], [-2, 9], [5, -1]],
      'Root' = [5, 1],
      'Product' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Shifted' = [[1, 0], [-4, -4], [-2, 9], [5, -1], [0, 0]],
      'Minusroot' = [-5, -1],
      'Scaled' = [[-5, -1], [16, 24], [19, -43], [-26, 0]],
      'Lower' = [[0, 0], [-5, -1], [16, 24], [19, -43], [-26, 0]]],
     [append([[1, 0], [-4, -4], [-2, 9], [5, -1]], [[0, 0]], [[1, 0], [-4, -4], [-2, 9], [5, -1], [0, 0]]),
      c_neg([5, 1], [-5, -1]),
      poly_scale([-5, -1], [[1, 0], [-4, -4], [-2, 9], [5, -1]], [[-5, -1], [16, 24], [19, -43], [-26, 0]]),
      append([[0, 0]], [[-5, -1], [16, 24], [19, -43], [-26, 0]], [[0, 0], [-5, -1], [16, 24], [19, -43], [-26, 0]]),
      poly_add([[1, 0], [-4, -4], [-2, 9], [5, -1], [0, 0]], [[0, 0], [-5, -1], [16, 24], [19, -43], [-26, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(append([[1, 0], [-4, -4], [-2, 9], [5, -1]], [[0, 0]], [[1, 0], [-4, -4], [-2, 9], [5, -1], [0, 0]]),
     builtin,
     [],
     []).
step(c_neg([5, 1], [-5, -1]),
     rule(14),
     ['A' = 5, 'B' = 1, 'C' = -5, 'D' = -1],
     [-5 is - (5), -1 is - (1)]).
step(-5 is - (5), builtin, [], []).
step(poly_scale([-5, -1], [[1, 0], [-4, -4], [-2, 9], [5, -1]], [[-5, -1], [16, 24], [19, -43], [-26, 0]]),
     rule(26),
     ['Factor' = [-5, -1],
      'Coeff' = [1, 0],
      'Rest' = [[-4, -4], [-2, 9], [5, -1]],
      'Product' = [-5, -1],
      'Scaled' = [[16, 24], [19, -43], [-26, 0]]],
     [c_mul([-5, -1], [1, 0], [-5, -1]),
      poly_scale([-5, -1], [[-4, -4], [-2, 9], [5, -1]], [[16, 24], [19, -43], [-26, 0]])]).
step(c_mul([-5, -1], [1, 0], [-5, -1]),
     rule(15),
     ['A' = -5,
      'B' = -1,
      'C' = 1,
      'D' = 0,
      'E' = -5,
      'F' = -1,
      'Ac' = -5,
      'Bd' = 0,
      'Ad' = 0,
      'Bc' = -1],
     [-5 is -5 * 1, 0 is -1 * 0, -5 is -5 - 0, 0 is -5 * 0, -1 is -1 * 1, -1 is 0 + -1]).
step(-5 is -5 * 1, builtin, [], []).
step(-5 is -5 - 0, builtin, [], []).
step(0 is -5 * 0, builtin, [], []).
step(poly_scale([-5, -1], [[-4, -4], [-2, 9], [5, -1]], [[16, 24], [19, -43], [-26, 0]]),
     rule(26),
     ['Factor' = [-5, -1],
      'Coeff' = [-4, -4],
      'Rest' = [[-2, 9], [5, -1]],
      'Product' = [16, 24],
      'Scaled' = [[19, -43], [-26, 0]]],
     [c_mul([-5, -1], [-4, -4], [16, 24]),
      poly_scale([-5, -1], [[-2, 9], [5, -1]], [[19, -43], [-26, 0]])]).
step(c_mul([-5, -1], [-4, -4], [16, 24]),
     rule(15),
     ['A' = -5,
      'B' = -1,
      'C' = -4,
      'D' = -4,
      'E' = 16,
      'F' = 24,
      'Ac' = 20,
      'Bd' = 4,
      'Ad' = 20,
      'Bc' = 4],
     [20 is -5 * -4, 4 is -1 * -4, 16 is 20 - 4, 20 is -5 * -4, 4 is -1 * -4, 24 is 20 + 4]).
step(20 is -5 * -4, builtin, [], []).
step(4 is -1 * -4, builtin, [], []).
step(16 is 20 - 4, builtin, [], []).
step(24 is 20 + 4, builtin, [], []).
step(poly_scale([-5, -1], [[-2, 9], [5, -1]], [[19, -43], [-26, 0]]),
     rule(26),
     ['Factor' = [-5, -1],
      'Coeff' = [-2, 9],
      'Rest' = [[5, -1]],
      'Product' = [19, -43],
      'Scaled' = [[-26, 0]]],
     [c_mul([-5, -1], [-2, 9], [19, -43]), poly_scale([-5, -1], [[5, -1]], [[-26, 0]])]).
step(c_mul([-5, -1], [-2, 9], [19, -43]),
     rule(15),
     ['A' = -5,
      'B' = -1,
      'C' = -2,
      'D' = 9,
      'E' = 19,
      'F' = -43,
      'Ac' = 10,
      'Bd' = -9,
      'Ad' = -45,
      'Bc' = 2],
     [10 is -5 * -2, -9 is -1 * 9, 19 is 10 - -9, -45 is -5 * 9, 2 is -1 * -2, -43 is -45 + 2]).
step(10 is -5 * -2, builtin, [], []).
step(-9 is -1 * 9, builtin, [], []).
step(19 is 10 - -9, builtin, [], []).
step(-45 is -5 * 9, builtin, [], []).
step(2 is -1 * -2, builtin, [], []).
step(-43 is -45 + 2, builtin, [], []).
step(poly_scale([-5, -1], [[5, -1]], [[-26, 0]]),
     rule(26),
     ['Factor' = [-5, -1], 'Coeff' = [5, -1], 'Rest' = [], 'Product' = [-26, 0], 'Scaled' = []],
     [c_mul([-5, -1], [5, -1], [-26, 0]), poly_scale([-5, -1], [], [])]).
step(c_mul([-5, -1], [5, -1], [-26, 0]),
     rule(15),
     ['A' = -5,
      'B' = -1,
      'C' = 5,
      'D' = -1,
      'E' = -26,
      'F' = 0,
      'Ac' = -25,
      'Bd' = 1,
      'Ad' = 5,
      'Bc' = -5],
     [-25 is -5 * 5, 1 is -1 * -1, -26 is -25 - 1, 5 is -5 * -1, -5 is -1 * 5, 0 is 5 + -5]).
step(-25 is -5 * 5, builtin, [], []).
step(-26 is -25 - 1, builtin, [], []).
step(5 is -5 * -1, builtin, [], []).
step(poly_scale([-5, -1], [], []), fact(25), [], []).
step(append([[0, 0]], [[-5, -1], [16, 24], [19, -43], [-26, 0]], [[0, 0], [-5, -1], [16, 24], [19, -43], [-26, 0]]),
     builtin,
     [],
     []).
step(poly_add([[1, 0], [-4, -4], [-2, 9], [5, -1], [0, 0]], [[0, 0], [-5, -1], [16, 24], [19, -43], [-26, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(28),
     ['A' = [1, 0],
      'As' = [[-4, -4], [-2, 9], [5, -1], [0, 0]],
      'B' = [0, 0],
      'Bs' = [[-5, -1], [16, 24], [19, -43], [-26, 0]],
      'C' = [1, 0],
      'Cs' = [[-9, -5], [14, 33], [24, -44], [-26, 0]]],
     [c_add([1, 0], [0, 0], [1, 0]),
      poly_add([[-4, -4], [-2, 9], [5, -1], [0, 0]], [[-5, -1], [16, 24], [19, -43], [-26, 0]], [[-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(poly_add([[-4, -4], [-2, 9], [5, -1], [0, 0]], [[-5, -1], [16, 24], [19, -43], [-26, 0]], [[-9, -5], [14, 33], [24, -44], [-26, 0]]),
     rule(28),
     ['A' = [-4, -4],
      'As' = [[-2, 9], [5, -1], [0, 0]],
      'B' = [-5, -1],
      'Bs' = [[16, 24], [19, -43], [-26, 0]],
      'C' = [-9, -5],
      'Cs' = [[14, 33], [24, -44], [-26, 0]]],
     [c_add([-4, -4], [-5, -1], [-9, -5]),
      poly_add([[-2, 9], [5, -1], [0, 0]], [[16, 24], [19, -43], [-26, 0]], [[14, 33], [24, -44], [-26, 0]])]).
step(c_add([-4, -4], [-5, -1], [-9, -5]),
     rule(12),
     ['A' = -4, 'B' = -4, 'C' = -5, 'D' = -1, 'E' = -9, 'F' = -5],
     [-9 is -4 + -5, -5 is -4 + -1]).
step(-9 is -4 + -5, builtin, [], []).
step(-5 is -4 + -1, builtin, [], []).
step(poly_add([[-2, 9], [5, -1], [0, 0]], [[16, 24], [19, -43], [-26, 0]], [[14, 33], [24, -44], [-26, 0]]),
     rule(28),
     ['A' = [-2, 9],
      'As' = [[5, -1], [0, 0]],
      'B' = [16, 24],
      'Bs' = [[19, -43], [-26, 0]],
      'C' = [14, 33],
      'Cs' = [[24, -44], [-26, 0]]],
     [c_add([-2, 9], [16, 24], [14, 33]),
      poly_add([[5, -1], [0, 0]], [[19, -43], [-26, 0]], [[24, -44], [-26, 0]])]).
step(c_add([-2, 9], [16, 24], [14, 33]),
     rule(12),
     ['A' = -2, 'B' = 9, 'C' = 16, 'D' = 24, 'E' = 14, 'F' = 33],
     [14 is -2 + 16, 33 is 9 + 24]).
step(14 is -2 + 16, builtin, [], []).
step(33 is 9 + 24, builtin, [], []).
step(poly_add([[5, -1], [0, 0]], [[19, -43], [-26, 0]], [[24, -44], [-26, 0]]),
     rule(28),
     ['A' = [5, -1],
      'As' = [[0, 0]],
      'B' = [19, -43],
      'Bs' = [[-26, 0]],
      'C' = [24, -44],
      'Cs' = [[-26, 0]]],
     [c_add([5, -1], [19, -43], [24, -44]), poly_add([[0, 0]], [[-26, 0]], [[-26, 0]])]).
step(c_add([5, -1], [19, -43], [24, -44]),
     rule(12),
     ['A' = 5, 'B' = -1, 'C' = 19, 'D' = -43, 'E' = 24, 'F' = -44],
     [24 is 5 + 19, -44 is -1 + -43]).
step(24 is 5 + 19, builtin, [], []).
step(-44 is -1 + -43, builtin, [], []).
step(poly_add([[0, 0]], [[-26, 0]], [[-26, 0]]),
     rule(28),
     ['A' = [0, 0], 'As' = [], 'B' = [-26, 0], 'Bs' = [], 'C' = [-26, 0], 'Cs' = []],
     [c_add([0, 0], [-26, 0], [-26, 0]), poly_add([], [], [])]).
step(c_add([0, 0], [-26, 0], [-26, 0]),
     rule(12),
     ['A' = 0, 'B' = 0, 'C' = -26, 'D' = 0, 'E' = -26, 'F' = 0],
     [-26 is 0 + -26, 0 is 0 + 0]).
step(-26 is 0 + -26, builtin, [], []).
step(poly_from_roots_acc([], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
     fact(22),
     ['Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]],
     []).
step(reconstructionMatches(real_quartic, true),
     rule(31),
     ['Case' = real_quartic, 'Coeffs' = [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]],
     [polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]),
      reconstructed(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]])]).
step(reconstructionMatches(complex_quartic, true),
     rule(31),
     ['Case' = complex_quartic, 'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      reconstructed(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]])]).
step(allRootsVerified(real_quartic, true),
     rule(32),
     ['Case' = real_quartic, 'Roots' = [[1, 0], [2, 0], [3, 0], [4, 0]]],
     [known_roots(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]),
      all_roots_verify(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]])]).
step(all_roots_verify(real_quartic, [[1, 0], [2, 0], [3, 0], [4, 0]]),
     rule(34),
     ['Case' = real_quartic, 'Root' = [1, 0], 'Rest' = [[2, 0], [3, 0], [4, 0]]],
     [root(real_quartic, [1, 0]), all_roots_verify(real_quartic, [[2, 0], [3, 0], [4, 0]])]).
step(all_roots_verify(real_quartic, [[2, 0], [3, 0], [4, 0]]),
     rule(34),
     ['Case' = real_quartic, 'Root' = [2, 0], 'Rest' = [[3, 0], [4, 0]]],
     [root(real_quartic, [2, 0]), all_roots_verify(real_quartic, [[3, 0], [4, 0]])]).
step(all_roots_verify(real_quartic, [[3, 0], [4, 0]]),
     rule(34),
     ['Case' = real_quartic, 'Root' = [3, 0], 'Rest' = [[4, 0]]],
     [root(real_quartic, [3, 0]), all_roots_verify(real_quartic, [[4, 0]])]).
step(all_roots_verify(real_quartic, [[4, 0]]),
     rule(34),
     ['Case' = real_quartic, 'Root' = [4, 0], 'Rest' = []],
     [root(real_quartic, [4, 0]), all_roots_verify(real_quartic, [])]).
step(all_roots_verify(real_quartic, []), fact(33), [], []).
step(allRootsVerified(complex_quartic, true),
     rule(32),
     ['Case' = complex_quartic, 'Roots' = [[0, 1], [1, 1], [3, 2], [5, 1]]],
     [known_roots(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]),
      all_roots_verify(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]])]).
step(all_roots_verify(complex_quartic, [[0, 1], [1, 1], [3, 2], [5, 1]]),
     rule(34),
     ['Case' = complex_quartic, 'Root' = [0, 1], 'Rest' = [[1, 1], [3, 2], [5, 1]]],
     [root(complex_quartic, [0, 1]),
      all_roots_verify(complex_quartic, [[1, 1], [3, 2], [5, 1]])]).
step(all_roots_verify(complex_quartic, [[1, 1], [3, 2], [5, 1]]),
     rule(34),
     ['Case' = complex_quartic, 'Root' = [1, 1], 'Rest' = [[3, 2], [5, 1]]],
     [root(complex_quartic, [1, 1]), all_roots_verify(complex_quartic, [[3, 2], [5, 1]])]).
step(all_roots_verify(complex_quartic, [[3, 2], [5, 1]]),
     rule(34),
     ['Case' = complex_quartic, 'Root' = [3, 2], 'Rest' = [[5, 1]]],
     [root(complex_quartic, [3, 2]), all_roots_verify(complex_quartic, [[5, 1]])]).
step(all_roots_verify(complex_quartic, [[5, 1]]),
     rule(34),
     ['Case' = complex_quartic, 'Root' = [5, 1], 'Rest' = []],
     [root(complex_quartic, [5, 1]), all_roots_verify(complex_quartic, [])]).
step(all_roots_verify(complex_quartic, []), fact(33), [], []).
