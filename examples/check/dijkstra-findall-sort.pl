condition('C1', resolution, ok, 15).
condition('C2', well_founded, ok, 50).
condition('C3', justification, ok, 50).
condition('C4', coverage, ok, 51).
condition('C5', re_decision, ok, 24).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 52).
obligation(collected, theory_scoped, findall([A, B, a], (edge(a, B, C), \+ member(B, []), A is 0 + C), [[4|"ba"], [2|"ca"]])).
obligation(collected, theory_scoped, findall([A, B|"ca"], (edge(c, B, C), \+ member(B, "a"), A is 2 + C), [[10|"dca"], [12|"eca"], [3|"bca"]])).
obligation(collected, theory_scoped, findall([A, B|"bca"], (edge(b, B, C), \+ member(B, "ca"), A is 3 + C), [[8|"dbca"]])).
obligation(collected, theory_scoped, findall([A, B|"ba"], (edge(b, B, C), \+ member(B, "bca"), A is 4 + C), [[9|"dba"]])).
obligation(collected, theory_scoped, findall([A, B|"dbca"], (edge(d, B, C), \+ member(B, "bbca"), A is 8 + C), [[10|"edbca"], [14|"fdbca"]])).
obligation(collected, theory_scoped, findall([A, B|"dba"], (edge(d, B, C), \+ member(B, "dbbca"), A is 9 + C), [[11|"edba"], [15|"fdba"]])).
obligation(collected, theory_scoped, findall([A, B|"dca"], (edge(d, B, C), \+ member(B, "ddbbca"), A is 10 + C), [[12|"edca"], [16|"fdca"]])).
obligation(collected, theory_scoped, findall([A, B|"edbca"], (edge(e, B, C), \+ member(B, "dddbbca"), A is 10 + C), [[13|"fedbca"]])).
obligation(collected, theory_scoped, findall([A, B|"edba"], (edge(e, B, C), \+ member(B, "edddbbca"), A is 11 + C), [[14|"fedba"]])).
obligation(collected, theory_scoped, findall([A, B|"eca"], (edge(e, B, C), \+ member(B, "eedddbbca"), A is 12 + C), [[15|"feca"]])).
obligation(collected, theory_scoped, findall([A, B|"edca"], (edge(e, B, C), \+ member(B, "eeedddbbca"), A is 12 + C), [[15|"fedca"]])).
steps(50).
verified(15).
recomputed(23).
composed(1).
trusted(11).
claims(2).
verdict(checked_with_obligations).
