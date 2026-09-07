% From The Art of EyeProlog, Chapter 8.
:- use_module(library(aggregate)).
:- use_module(library(lists)).

outgoing_costs(Node, Costs) :-
  findall(Cost, edge(Node, _, Cost), Costs).

total_outgoing(Node, Total) :-
  sumall(Cost, edge(Node, _, Cost), Total).
