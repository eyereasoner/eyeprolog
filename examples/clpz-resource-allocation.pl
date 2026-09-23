:- use_module(library(clpz)).

% A small allocation model exercises element and chain constraints, a scalar
% product, a sum with a derived total, reification, labeling options, and
% domain reflection. Worker numbers select job-specific duration tables.

%% ?- clpz_example(X0, X1).

clpz_example(allocation, plan([A, B, C], durations([DA, DB, DC]), Total)) :-
  [A, B, C] ins 1..3,
  all_distinct([A, B, C]),
  scalar_product([1, 2, 3], [A, B, C], #=, 11),
  element(A, [5, 3, 4], DA),
  element(B, [4, 6, 2], DB),
  element(C, [7, 2, 5], DC),
  chain(#>=, [DA, DB]),
  sum([DA, DB, DC], #=, Total),
  Fast in 0..1,
  Fast #<==> Total #=< 12,
  Fast #= 1,
  labeling([ff, down], [A, B, C, Fast]).

clpz_example(domain, domain(Infimum, Supremum, Size, Domain)) :-
  X in 2..4 \/ 7,
  fd_var(X),
  fd_inf(X, Infimum),
  fd_sup(X, Supremum),
  fd_size(X, Size),
  fd_dom(X, Domain).
