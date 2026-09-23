% STC #67: the clarifying bagof/3 example retains proof/answer order.
% https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#67
%% ?- bagof_answer_order.

bagof_answer_order :-
  bagof(X, (X = 2 ; X = 1), [2, 1]).
