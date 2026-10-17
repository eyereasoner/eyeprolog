move(1, 1, proponent, claims(valid(c17))).
move(1, 2, opponent, why(valid(c17))).
move(1,
     3,
     proponent,
     because(valid(c17), rule(15), [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), \+ minor_party(c17)])).
move(1, 4, opponent, concedes(offer(c17, bob, ann))).
move(1, 5, opponent, concedes(accepted(c17, ann))).
move(1, 6, opponent, concedes(consideration(c17))).
move(1, 7, opponent, grants(\+ minor_party(c17))).
outcome(1, valid(c17), won).
obligation(1, \+ minor_party(c17)).
move(2, 1, proponent, claims(valid(c18))).
move(2, 2, opponent, why(valid(c18))).
move(2,
     3,
     proponent,
     because(valid(c18), rule(15), [offer(c18, eve, dave), accepted(c18, dave), consideration(c18), \+ minor_party(c18)])).
move(2, 4, opponent, concedes(offer(c18, eve, dave))).
move(2, 5, opponent, concedes(accepted(c18, dave))).
move(2, 6, opponent, concedes(consideration(c18))).
move(2, 7, opponent, grants(\+ minor_party(c18))).
outcome(2, valid(c18), won).
obligation(2, \+ minor_party(c18)).
