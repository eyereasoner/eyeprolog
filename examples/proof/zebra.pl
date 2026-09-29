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
     [[__anon0, __anon1, __anon2, __anon3, __anon4] = [__anon0, __anon1, __anon2, __anon3, __anon4],
      first([house(__anon5, norwegian, __anon6, __anon7, __anon8), __anon1, __anon2, __anon3, __anon4], house(__anon5, norwegian, __anon6, __anon7, __anon8)),
      third([house(__anon5, norwegian, __anon6, __anon7, __anon8), __anon77, house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4], house(__anon9, __anon10, __anon11, milk, __anon12)),
      adjacent(house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4]),
      next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
      member(house(red, english, __anon11, milk, __anon12), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
      member(house(green, __anon25, __anon26, coffee, __anon28), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(yellow, norwegian, __anon14, __anon15, kools), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(ivory, spanish, dog, __anon23, __anon24), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(blue, ukrainian, __anon18, tea, __anon20), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, ukrainian, __anon18, tea, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(red, english, snail, milk, old_gold), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, ukrainian, __anon18, tea, __anon20), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      adjacent(house(blue, ukrainian, __anon49, tea, chesterfields), house(yellow, norwegian, fox, __anon53, kools), [house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      adjacent(house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(ivory, spanish, dog, orange_juice, lucky_strike), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, __anon25, __anon26, coffee, __anon28)]),
      member(house(green, japanese, __anon26, coffee, parliaments), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, __anon26, coffee, parliaments)]),
      member(house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, __anon26, coffee, parliaments)]),
      member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)])]).
step([__anon0, __anon1, __anon2, __anon3, __anon4] = [__anon0, __anon1, __anon2, __anon3, __anon4],
     builtin,
     [],
     []).
step(first([house(__anon5, norwegian, __anon6, __anon7, __anon8), __anon1, __anon2, __anon3, __anon4], house(__anon5, norwegian, __anon6, __anon7, __anon8)),
     fact(2),
     ['X' = house(__anon5, norwegian, __anon6, __anon7, __anon8)],
     []).
step(third([house(__anon5, norwegian, __anon6, __anon7, __anon8), __anon77, house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4], house(__anon9, __anon10, __anon11, milk, __anon12)),
     fact(3),
     ['X' = house(__anon9, __anon10, __anon11, milk, __anon12)],
     []).
step(adjacent(house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4]),
     rule(4),
     ['A' = house(__anon13, norwegian, __anon14, __anon15, __anon16),
      'B' = house(blue, __anon17, __anon18, __anon19, __anon20),
      'List' = [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4]],
     [next_to(house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4])]).
step(next_to(house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), __anon3, __anon4]),
     fact(6),
     ['X' = house(__anon13, norwegian, __anon14, __anon15, __anon16),
      'Y' = house(blue, __anon17, __anon18, __anon19, __anon20)],
     []).
step(next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
     rule(7),
     ['X' = house(ivory, __anon21, __anon22, __anon23, __anon24),
      'Y' = house(green, __anon25, __anon26, __anon27, __anon28),
      'Zs' = [house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]],
     [next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)])]).
step(next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(blue, __anon17, __anon18, __anon19, __anon20), house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
     rule(7),
     ['X' = house(ivory, __anon21, __anon22, __anon23, __anon24),
      'Y' = house(green, __anon25, __anon26, __anon27, __anon28),
      'Zs' = [house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]],
     [next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)])]).
step(next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(__anon9, __anon10, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
     rule(7),
     ['X' = house(ivory, __anon21, __anon22, __anon23, __anon24),
      'Y' = house(green, __anon25, __anon26, __anon27, __anon28),
      'Zs' = [house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]],
     [next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)])]).
step(next_to(house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28), [house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
     fact(6),
     ['X' = house(ivory, __anon21, __anon22, __anon23, __anon24),
      'Y' = house(green, __anon25, __anon26, __anon27, __anon28)],
     []).
step(member(house(red, english, __anon11, milk, __anon12), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, __anon27, __anon28)]),
     builtin,
     [],
     []).
step(member(house(green, __anon25, __anon26, coffee, __anon28), [house(__anon13, norwegian, __anon14, __anon15, __anon16), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(member(house(yellow, norwegian, __anon14, __anon15, kools), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, __anon21, __anon22, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(member(house(ivory, spanish, dog, __anon23, __anon24), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, __anon17, __anon18, __anon19, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(member(house(blue, ukrainian, __anon18, tea, __anon20), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, ukrainian, __anon18, tea, __anon20), house(red, english, __anon11, milk, __anon12), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(member(house(red, english, snail, milk, old_gold), [house(yellow, norwegian, __anon14, __anon15, kools), house(blue, ukrainian, __anon18, tea, __anon20), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(adjacent(house(blue, ukrainian, __anon49, tea, chesterfields), house(yellow, norwegian, fox, __anon53, kools), [house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     rule(5),
     ['A' = house(blue, ukrainian, __anon49, tea, chesterfields),
      'B' = house(yellow, norwegian, fox, __anon53, kools),
      'List' = [house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]],
     [next_to(house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), [house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)])]).
step(next_to(house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), [house(yellow, norwegian, fox, __anon53, kools), house(blue, ukrainian, __anon49, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     fact(6),
     ['X' = house(yellow, norwegian, fox, __anon53, kools),
      'Y' = house(blue, ukrainian, __anon49, tea, chesterfields)],
     []).
step(adjacent(house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     rule(4),
     ['A' = house(yellow, norwegian, fox, __anon58, kools),
      'B' = house(blue, ukrainian, horse, tea, chesterfields),
      'List' = [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]],
     [next_to(house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)])]).
step(next_to(house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, __anon23, __anon24), house(green, __anon25, __anon26, coffee, __anon28)]),
     fact(6),
     ['X' = house(yellow, norwegian, fox, __anon58, kools),
      'Y' = house(blue, ukrainian, horse, tea, chesterfields)],
     []).
step(member(house(ivory, spanish, dog, orange_juice, lucky_strike), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, __anon25, __anon26, coffee, __anon28)]),
     builtin,
     [],
     []).
step(member(house(green, japanese, __anon26, coffee, parliaments), [house(yellow, norwegian, fox, __anon58, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, __anon26, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(yellow, norwegian, fox, water, kools), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, __anon26, coffee, parliaments)]),
     builtin,
     [],
     []).
step(member(house(green, japanese, zebra, coffee, parliaments), [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]),
     builtin,
     [],
     []).
step(zebraOwner(zebraPuzzle, japanese),
     rule(9),
     ['Zebraowner' = japanese],
     [zebra(norwegian, japanese)]).
step(solved(zebraPuzzle, true), rule(10), [], [zebra(norwegian, japanese)]).
