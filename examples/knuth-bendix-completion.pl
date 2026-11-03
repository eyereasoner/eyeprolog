:- use_module(library(lists)).
:- use_module(library(iso_ext)).

% Bounded Knuth-Bendix-style completion for append/2 terms.
%
% Full Knuth-Bendix completion orients equations, generates all critical pairs,
% reduces them, and may add new rules until all overlaps are joinable.  That is
% a difficult global search problem.  This example keeps the recognizable shape
% but bounds the hard part: the rewrite system is fixed, and a small catalog of
% critical overlaps is checked for joinability by normalization.

%% ?- kbAnswer(X0, X1).



% Oriented equations for a monoid-like append constructor.
%   append(nil, x)       -> x
%   append(x, nil)       -> x
%   append(append(x,y),z)-> append(x, append(y,z))
% The third rule right-associates terms so normalization terminates here.
oriented_rule(left_identity, append(nil, X), X).
oriented_rule(right_identity, append(X, nil), X).
oriented_rule(associate_right, append(append(X, Y), Z), append(X, append(Y, Z))).

% One rewrite at the root or below an append node. With a finite ground input,
% recursion visits strict subterms, so this search has finitely many answers.
% An open first argument is not a supported mode of this normalizer.
rewrite_once(In, Out, Rule) :- oriented_rule(Rule, In, Out).
rewrite_once(append(A, B), append(New_a, B), Rule) :- rewrite_once(A, New_a, Rule).
rewrite_once(append(A, B), append(A, New_b), Rule) :- rewrite_once(B, New_b, Rule).

% normal_form(+Term, ?Normal): Term must be a finite ground constructor term.
% ISO/IEC 13211-1:1995, 7.8.8 commits to the first successful condition.
% Probe for a rewrite once, before using Normal, so supplying Normal does not
% change the selected path. Failure later in that path cannot take the else.
% The fixed rules terminate and are confluent on these terms; choosing one
% path does not establish confluence for an arbitrary rewrite system.
normal_form(Term, Normal) :-
  ( rewrite_once(Term, Next, _) ->
      normal_form(Next, Normal)
  ; Normal = Term
  ).

% A few critical pairs that arise from overlapping the three oriented rules.
% Each pair records the two one-step reducts that must later normalize together.
critical_pair(left_identity_assoc,
  append(a, b),
  append(nil, append(a, b))).
critical_pair(right_identity_assoc,
  append(a, b),
  append(a, append(nil, b))).
critical_pair(nested_assoc,
  append(append(a, append(b, c)), d),
  append(append(a, b), append(c, d))).

joined_pair(Name) :-
  critical_pair(Name, Left, Right),
  normal_form(Left, Normal),
  normal_form(Right, Normal).

sample_term(append(append(nil, append(a, nil)), append(b, c))).

kbAnswer(sample_normal_form, Normal) :- sample_term(Term), normal_form(Term, Normal).
kbAnswer(joined_critical_pair, Name) :- joined_pair(Name).
kbAnswer(oriented_rule_count, Count) :- countall(oriented_rule(_, _, _), Count).
kbAnswer(joined_critical_pair_count, Count) :- countall(joined_pair(_), Count).
kbAnswer(note, "a bounded completion check proves the selected critical pairs join") :- joined_pair(nested_assoc).
