move(1, 1, proponent, claims(valid(c17))).
move(1, 2, opponent, why(valid(c17))).
move(1, 3, proponent, because(valid(c17), r1, [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), not(minor_party(c17))])).
move(1, 4, opponent, concedes(offer(c17, bob, ann))).
move(1, 5, opponent, concedes(accepted(c17, ann))).
move(1, 6, opponent, concedes(consideration(c17))).
move(1, 7, opponent, grants(not(minor_party(c17)))).
move(2, 1, proponent, claims(valid(c17))).
move(2, 2, opponent, why(valid(c17))).
move(2, 3, proponent, because(valid(c17), r1, [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), not(minor_party(c17))])).
move(2, 4, opponent, concedes(offer(c17, bob, ann))).
move(2, 5, opponent, concedes(accepted(c17, ann))).
move(2, 6, opponent, concedes(consideration(c17))).
move(2, 7, opponent, counters(not(minor_party(c17)), [born(ann, 2009)])).
move(2, 8, proponent, retracts(valid(c17), r1)).
move(2, 9, proponent, because(valid(c17), r2, [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), ratified_at_majority(c17)])).
move(2, 10, opponent, concedes(offer(c17, bob, ann))).
move(2, 11, opponent, concedes(accepted(c17, ann))).
move(2, 12, opponent, concedes(consideration(c17))).
move(2, 13, opponent, why(ratified_at_majority(c17))).
move(2, 14, proponent, because(ratified_at_majority(c17), r4, [ratified(c17, ann, 2028), born(ann, 2009), test(2028 - 2009 >= 18)])).
move(2, 15, opponent, concedes(ratified(c17, ann, 2028))).
move(2, 16, opponent, concedes(born(ann, 2009))).
move(2, 17, opponent, verifies(2028 - 2009 >= 18)).
move(3, 1, proponent, claims(valid(c18))).
move(3, 2, opponent, why(valid(c18))).
move(3, 3, proponent, because(valid(c18), r1, [offer(c18, eve, dave), accepted(c18, dave), consideration(c18), not(minor_party(c18))])).
move(3, 4, opponent, concedes(offer(c18, eve, dave))).
move(3, 5, opponent, concedes(accepted(c18, dave))).
move(3, 6, opponent, concedes(consideration(c18))).
move(3, 7, opponent, counters(not(minor_party(c18)), [born(dave, 2010)])).
move(3, 8, proponent, retracts(valid(c18), r1)).
move(3, 9, proponent, because(valid(c18), r2, [offer(c18, eve, dave), accepted(c18, dave), consideration(c18), ratified_at_majority(c18)])).
move(3, 10, opponent, concedes(offer(c18, eve, dave))).
move(3, 11, opponent, concedes(accepted(c18, dave))).
move(3, 12, opponent, concedes(consideration(c18))).
move(3, 13, opponent, why(ratified_at_majority(c18))).
move(3, 14, proponent, because(ratified_at_majority(c18), r4, [ratified(c18, unknown(1), unknown(2)), born(unknown(1), unknown(3)), test(unknown(2) - unknown(3) >= 18)])).
move(3, 15, opponent, why(ratified(c18, unknown(1), unknown(2)))).
move(3, 16, proponent, gives_up(ratified(c18, unknown(1), unknown(2)))).
move(3, 17, proponent, retracts(ratified_at_majority(c18), r4)).
move(3, 18, proponent, gives_up(ratified_at_majority(c18))).
move(3, 19, proponent, retracts(valid(c18), r2)).
move(3, 20, proponent, gives_up(valid(c18))).
outcome(1, valid(c17), won).
outcome(2, valid(c17), won).
outcome(3, valid(c18), lost).
obligation(1, not(minor_party(c17))).
