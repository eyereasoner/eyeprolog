condition('C1', resolution, ok, 15).
condition('C2', well_founded, ok, 50).
condition('C3', justification, ok, 50).
condition('C4', coverage, ok, 51).
condition('C5', re_decision, ok, 24).
obligation(collected, theory_scoped, findall([Newcost, Neighbor, a], (edge(a, Neighbor, Weight), \+ member(Neighbor, []), Newcost is 0 + Weight), [[4|"ba"], [2|"ca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"ca"], (edge(c, Neighbor, Weight), \+ member(Neighbor, "a"), Newcost is 2 + Weight), [[10|"dca"], [12|"eca"], [3|"bca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"bca"], (edge(b, Neighbor, Weight), \+ member(Neighbor, "ca"), Newcost is 3 + Weight), [[8|"dbca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"ba"], (edge(b, Neighbor, Weight), \+ member(Neighbor, "bca"), Newcost is 4 + Weight), [[9|"dba"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"dbca"], (edge(d, Neighbor, Weight), \+ member(Neighbor, "bbca"), Newcost is 8 + Weight), [[10|"edbca"], [14|"fdbca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"dba"], (edge(d, Neighbor, Weight), \+ member(Neighbor, "dbbca"), Newcost is 9 + Weight), [[11|"edba"], [15|"fdba"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"dca"], (edge(d, Neighbor, Weight), \+ member(Neighbor, "ddbbca"), Newcost is 10 + Weight), [[12|"edca"], [16|"fdca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"edbca"], (edge(e, Neighbor, Weight), \+ member(Neighbor, "dddbbca"), Newcost is 10 + Weight), [[13|"fedbca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"edba"], (edge(e, Neighbor, Weight), \+ member(Neighbor, "edddbbca"), Newcost is 11 + Weight), [[14|"fedba"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"eca"], (edge(e, Neighbor, Weight), \+ member(Neighbor, "eedddbbca"), Newcost is 12 + Weight), [[15|"feca"]])).
obligation(collected, theory_scoped, findall([Newcost, Neighbor|"edca"], (edge(e, Neighbor, Weight), \+ member(Neighbor, "eeedddbbca"), Newcost is 12 + Weight), [[15|"fedca"]])).
steps(50).
verified(15).
recomputed(23).
composed(1).
trusted(11).
claims(2).
verdict(checked_with_obligations).
