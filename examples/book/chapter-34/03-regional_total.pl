% From The Art of EyeProlog, Chapter 34 — Grouped solutions.
regional_total(Region, Total) :-
  bagof(Amount, Seller^sale(Region, Seller, Amount), Amounts),
  sum_amounts(Amounts, Total).
