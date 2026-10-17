move(1, 1, proponent, claims(valid(c17))).
move(1, 2, opponent, why(valid(c17))).
move(1,
     3,
     proponent,
     because(valid(c17), rule(15), [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), \+ minor_party(c17)])).
move(1, 4, opponent, concedes(offer(c17, bob, ann))).
move(1, 5, opponent, concedes(accepted(c17, ann))).
move(1, 6, opponent, concedes(consideration(c17))).
move(1, 7, opponent, counters(\+ minor_party(c17), minor_party(c17), [born(ann, 2009)])).
move(1, 8, proponent, retracts(valid(c17), rule(15))).
move(1, 9, opponent, why(valid(c17))).
move(1,
     10,
     proponent,
     because(valid(c17), rule(16), [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), ratified_at_majority(c17)])).
move(1, 11, opponent, concedes(offer(c17, bob, ann))).
move(1, 12, opponent, concedes(accepted(c17, ann))).
move(1, 13, opponent, concedes(consideration(c17))).
move(1, 14, opponent, why(ratified_at_majority(c17))).
move(1,
     15,
     proponent,
     because(ratified_at_majority(c17), rule(14), [ratified(c17, ann, 2028), born(ann, 2009), 2028 - 2009 >= 18])).
move(1, 16, opponent, concedes(ratified(c17, ann, 2028))).
move(1, 17, opponent, concedes(born(ann, 2009))).
move(1, 18, opponent, verifies(2028 - 2009 >= 18)).
outcome(1, valid(c17), won).
move(2, 1, proponent, claims(valid(c18))).
move(2, 2, opponent, why(valid(c18))).
move(2,
     3,
     proponent,
     because(valid(c18), rule(15), [offer(c18, eve, dave), accepted(c18, dave), consideration(c18), \+ minor_party(c18)])).
move(2, 4, opponent, concedes(offer(c18, eve, dave))).
move(2, 5, opponent, concedes(accepted(c18, dave))).
move(2, 6, opponent, concedes(consideration(c18))).
move(2, 7, opponent, counters(\+ minor_party(c18), minor_party(c18), [born(dave, 2010)])).
move(2, 8, proponent, retracts(valid(c18), rule(15))).
move(2, 9, proponent, gives_up(valid(c18))).
outcome(2, valid(c18), lost).
