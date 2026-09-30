condition('C1', resolution, ok, 12).
condition('C2', well_founded, ok, 21).
condition('C3', justification, ok, 21).
condition('C4', coverage, ok, 22).
condition('C5', re_decision, ok, 4).
obligation(collected, theory_scoped, findall(Amount, sale(__anon0, __anon1, Amount), [7, 7, 5, 9])).
obligation(builtin, theory_scoped, bagof(Amount, Seller ^ sale(north, Seller, Amount), [7, 7, 5])).
obligation(builtin, theory_scoped, bagof(Amount, Seller ^ sale(south, Seller, Amount), [9])).
obligation(builtin, theory_scoped, setof(Region, Seller ^ Amount ^ sale(Region, Seller, Amount), [north, south])).
obligation(builtin, reflective, clause(sale(north, ada, 7), true)).
steps(21).
verified(12).
recomputed(4).
composed(0).
trusted(5).
claims(5).
verdict(checked_with_obligations).
