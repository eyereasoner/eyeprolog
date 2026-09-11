% Defeasible reasoning: an employee travel-expense reimbursement policy.
%
% Defeasible rules state a default and let a more specific rule override it.
% Most of that is ordinary, stratified negation as failure (7.3, \+/1): compute
% the exception from facts, then let the default rule negate the exception.
% Nothing here needs the well-founded semantics (WFS) yet.
%
% The last section is different on purpose. It models two independent
% reimbursement policies that can both claim the same expense with no company
% rule saying which one wins — team_offsite_hotel qualifies for both the flat
% per-diem blanket allowance and itemized reimbursement, and neither policy
% was written anticipating the other. Three ways to handle that:
%
%   1) Plain \+/1, each side negating the other. That is an unstratified
%      negation cycle: proving either side requires failing the other, which
%      requires proving the first again. Try it (swap tnot/1 for \+/1 below
%      and run with --warnings): the engine loops until it runs out of stack.
%   2) tnot/1 and wfs_truth/2. EyeProlog evaluates the same cycle under WFS
%      and reports both sides `undefined` instead of picking one arbitrarily
%      — honest, since the policies themselves do not resolve the conflict,
%      but callers now have to know to ask wfs_truth/2 instead of just
%      calling covered_by_blanket/1 or itemized/1 directly.
%   3) An explicit conflict predicate, the way examples/nixon-diamond.pl
%      already handles the same shape of problem (two independent defaults,
%      no priority between them): join the two eligibility facts directly and
%      name the outcome. No negation, no cycle, nothing for --warnings to
%      flag, and the result is an ordinary fact any caller can query without
%      having to know WFS exists.
%
% Here (3) is the better fit, and is this codebase's actual convention for
% this situation. Reach for tnot/1 and wfs_truth/2 when the mutual defeat is
% already how the rules are naturally stated as each other's negation — a
% permission that holds unless its prohibition holds and vice versa, as
% examples/odrl-policy-reasoning.pl's profile rules do for a real policy
% language — not to manufacture a cycle for a conflict a direct join would
% already detect. And for everyday defeasible overriding, where a more
% specific rule is meant to win outright, plain stratified \+/1 already says
% exactly that and is ISO-portable; WFS would not change the answer there,
% only the machinery needed to get it.

%% goal: reimbursementQuestion(X0, X1, X2)
%% goal: conflictQuestion(X0, X1, X2)
%% goal: explicitConflictQuestion(X0, X1, X2)

% --- Submitted expenses and the facts a claims clerk would see ------------

submitted(taxi_receipt).
submitted(client_dinner_wine).
submitted(client_dinner_wine_preapproved).
submitted(team_offsite_hotel).

category(client_dinner_wine, alcohol).
category(client_dinner_wine_preapproved, alcohol).

% A manager can preapprove alcohol as part of client entertainment; that is
% the exception to the exception.
preapproved_entertainment(client_dinner_wine_preapproved).

% --- Ordinary defeasible tier: specificity resolves every case -------------
%
%   default:            an expense is reimbursable
%   exception:           ... unless it is alcohol
%   exception to that:   ... unless the alcohol was preapproved entertainment
%
% Each rule only negates a lower, already-computed layer, so this is
% stratified and plain \+/1 is all it takes.

excluded(Expense) :-
  category(Expense, alcohol),
  \+ preapproved_entertainment(Expense).

reimbursable(Expense) :-
  submitted(Expense),
  \+ excluded(Expense).

% --- The one case with a genuine, unresolved conflict, two ways ------------
%
% team_offsite_hotel independently qualifies for both the flat per-diem
% blanket allowance and itemized reimbursement.
blanket_eligible(team_offsite_hotel).
itemizable(team_offsite_hotel).

% 2) WFS via tnot/1: each classification defeats the other, leaving both
% `undefined` rather than an arbitrary pick.
covered_by_blanket(Expense) :-
  blanket_eligible(Expense),
  tnot(itemized(Expense)).
itemized(Expense) :-
  itemizable(Expense),
  tnot(covered_by_blanket(Expense)).

% 3) This codebase's usual idiom (examples/nixon-diamond.pl): detect the
% conflict directly from the two eligibility facts, no negation involved.
policy_conflict(Expense, blanket_allowance, itemized_reimbursement) :-
  blanket_eligible(Expense),
  itemizable(Expense).

% --- Curated questions -----------------------------------------------------

% Plain expense, alcohol excluded by default, and the preapproved override —
% all decided by ordinary negation as failure, no WFS involved.
reimbursementQuestion(plain, taxi_receipt, Verdict) :-
  wfs_truth(reimbursable(taxi_receipt), Verdict).
reimbursementQuestion(alcohol_excluded, client_dinner_wine, Verdict) :-
  wfs_truth(reimbursable(client_dinner_wine), Verdict).
reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, Verdict) :-
  wfs_truth(reimbursable(client_dinner_wine_preapproved), Verdict).

% The unresolved policy conflict under WFS: both classifications come back
% `undefined`, which only tells a caller anything if it remembers to ask
% wfs_truth/2 in the first place.
conflictQuestion(blanket_allowance, team_offsite_hotel, Verdict) :-
  wfs_truth(covered_by_blanket(team_offsite_hotel), Verdict).
conflictQuestion(itemized_reimbursement, team_offsite_hotel, Verdict) :-
  wfs_truth(itemized(team_offsite_hotel), Verdict).

% The same conflict, detected directly: an ordinary fact any caller can query
% without knowing WFS is involved at all.
explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement) :-
  policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement).
