waterDrinker(zebraPuzzle, norwegian).
zebraOwner(zebraPuzzle, japanese).
solved(zebraPuzzle, true).

clause(1,
       zebra(var('Waterdrinker'), var('Zebraowner')),
       (var('Houses') = [anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5)],
        first(var('Houses'), house(anonymous(6), norwegian, anonymous(7), anonymous(8), anonymous(9))),
        third(var('Houses'), house(anonymous(10), anonymous(11), anonymous(12), milk, anonymous(13))),
        adjacent(house(anonymous(14), norwegian, anonymous(15), anonymous(16), anonymous(17)), house(blue, anonymous(18), anonymous(19), anonymous(20), anonymous(21)), var('Houses')),
        next_to(house(ivory, anonymous(22), anonymous(23), anonymous(24), anonymous(25)), house(green, anonymous(26), anonymous(27), anonymous(28), anonymous(29)), var('Houses')),
        member(house(red, english, anonymous(30), anonymous(31), anonymous(32)), var('Houses')),
        member(house(green, anonymous(33), anonymous(34), coffee, anonymous(35)), var('Houses')),
        member(house(yellow, anonymous(36), anonymous(37), anonymous(38), kools), var('Houses')),
        member(house(anonymous(39), spanish, dog, anonymous(40), anonymous(41)), var('Houses')),
        member(house(anonymous(42), ukrainian, anonymous(43), tea, anonymous(44)), var('Houses')),
        member(house(anonymous(45), anonymous(46), snail, anonymous(47), old_gold), var('Houses')),
        adjacent(house(anonymous(48), anonymous(49), anonymous(50), anonymous(51), chesterfields), house(anonymous(52), anonymous(53), fox, anonymous(54), anonymous(55)), var('Houses')),
        adjacent(house(anonymous(56), anonymous(57), anonymous(58), anonymous(59), kools), house(anonymous(60), anonymous(61), horse, anonymous(62), anonymous(63)), var('Houses')),
        member(house(anonymous(64), anonymous(65), anonymous(66), orange_juice, lucky_strike), var('Houses')),
        member(house(anonymous(67), japanese, anonymous(68), anonymous(69), parliaments), var('Houses')),
        member(house(anonymous(70), var('Waterdrinker'), anonymous(71), water, anonymous(72)), var('Houses')),
        member(house(anonymous(73), var('Zebraowner'), zebra, anonymous(74), anonymous(75)), var('Houses')))).
clause(2, first([var('X') | anonymous(1)], var('X')), true).
clause(3, third([anonymous(1), anonymous(2), var('X') | anonymous(3)], var('X')), true).
clause(4, adjacent(var('A'), var('B'), var('List')), next_to(var('A'), var('B'), var('List'))).
clause(5, adjacent(var('A'), var('B'), var('List')), next_to(var('B'), var('A'), var('List'))).
clause(6, next_to(var('X'), var('Y'), [var('X'), var('Y') | anonymous(1)]), true).
clause(7,
       next_to(var('X'), var('Y'), [anonymous(1) | var('Zs')]),
       next_to(var('X'), var('Y'), var('Zs'))).
clause(8,
       waterDrinker(zebraPuzzle, var('Waterdrinker')),
       zebra(var('Waterdrinker'), anonymous(1))).
clause(9, zebraOwner(zebraPuzzle, var('Zebraowner')), zebra(anonymous(1), var('Zebraowner'))).
clause(10, solved(zebraPuzzle, true), zebra(norwegian, japanese)).

step(waterDrinker(zebraPuzzle, norwegian),
     rule(8),
     ['Waterdrinker' = norwegian],
     [zebra(norwegian, japanese)]).
step(zebra(norwegian, japanese),
     rule(1),
     ['Waterdrinker' = norwegian,
      'Zebraowner' = japanese,
      'Houses' = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [[house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)] = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)],
      first([house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)], house(yellow, norwegian, fox, water, kools)),
      third([house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)], house(red, english, snail, milk, old_gold)),
      adjacent(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(red, english, snail, milk, old_gold), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(ivory, spanish, dog, orange_juice, lucky_strike), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(red, english, snail, milk, old_gold), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      adjacent(house(blue, ukrainian, horse, tea, chesterfields), house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      adjacent(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(ivory, spanish, dog, orange_juice, lucky_strike), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
      member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step([house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)] = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)],
     builtin,
     [],
     []).
step(first([house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)], house(yellow, norwegian, fox, water, kools)),
     fact(2),
     ['X' = house(yellow, norwegian, fox, water, kools)],
     []).
step(third([house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)], house(red, english, snail, milk, old_gold)),
     fact(3),
     ['X' = house(red, english, snail, milk, old_gold)],
     []).
step(adjacent(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     rule(4),
     ['A' = house(yellow, norwegian, fox, water, kools),
      'B' = house(blue, ukrainian, horse, tea, chesterfields),
      'List' = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [next_to(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step(next_to(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     fact(6),
     ['X' = house(yellow, norwegian, fox, water, kools),
      'Y' = house(blue, ukrainian, horse, tea, chesterfields)],
     []).
step(next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     rule(7),
     ['X' = house(ivory, spanish, dog, orange_juice, lucky_strike),
      'Y' = house(green, japanese, zebra, coffee, parliaments),
      'Zs' = [house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step(next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     rule(7),
     ['X' = house(ivory, spanish, dog, orange_juice, lucky_strike),
      'Y' = house(green, japanese, zebra, coffee, parliaments),
      'Zs' = [house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step(next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     rule(7),
     ['X' = house(ivory, spanish, dog, orange_juice, lucky_strike),
      'Y' = house(green, japanese, zebra, coffee, parliaments),
      'Zs' = [house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step(next_to(house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments), [house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     fact(6),
     ['X' = house(ivory, spanish, dog, orange_juice, lucky_strike),
      'Y' = house(green, japanese, zebra, coffee, parliaments)],
     []).
step(member(house(red, english, snail, milk, old_gold), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(ivory, spanish, dog, orange_juice, lucky_strike), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(adjacent(house(blue, ukrainian, horse, tea, chesterfields), house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     rule(5),
     ['A' = house(blue, ukrainian, horse, tea, chesterfields),
      'B' = house(yellow, norwegian, fox, water, kools),
      'List' = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
     [next_to(house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step(zebraOwner(zebraPuzzle, japanese),
     rule(9),
     ['Zebraowner' = japanese],
     [zebra(norwegian, japanese)]).
step(solved(zebraPuzzle, true), rule(10), [], [zebra(norwegian, japanese)]).
