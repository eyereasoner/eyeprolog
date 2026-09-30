% An authority demands evidence, then withdraws the demand as one it was never
% permitted to make. Three questions survive the withdrawal, and none of them
% is answered by "never mind": was the status ever at risk, may the missed
% deadline count against the holder, and what becomes of evidence that was
% handed over while the demand still looked binding?
%
% The case is modelled so that each of those is a separate query with its own
% derivation, because they have different answers. Withdrawing a demand settles
% the first. It does not by itself settle the other two.
%
% The reasoning rests on one distinction the engine takes seriously elsewhere:
% not proving something is not the same as disproving it. The holder never
% showed they still met the conditions. That is not a finding that they did
% not, and a ground for termination needs the finding, not the silence.

:- dynamic(breached/2).

%% ?- demand_validity(X0, X1).

%% ?- termination_ground(X0, X1).

%% ?- admissible(X0, X1).

%% ?- holder_status(X0, X1).


% What the authority may ask for at all. A power is granted for a purpose; a
% demand outside it is not a weaker demand, it is not a demand.
may_demand(authority, evidence_of(criminal_record)).
may_demand(authority, evidence_of(identity)).

% What was actually demanded, and under what deadline.
demanded(authority, holder, evidence_of(continued_conditions), deadline(30)).
withdrawn(authority, evidence_of(continued_conditions), reason(not_permitted_to_ask)).

% What happened. The holder let the deadline pass, and separately had already
% sent one document while the demand still appeared to bind.
elapsed(deadline(30)).
produced(holder, document(tenancy_record), under(evidence_of(continued_conditions))).

% The conditions of the status itself, and what is actually known about them.
condition_of_status(lawful_residence).
condition_of_status(no_relevant_conviction).

% Breaches are recorded here. The relation is declared and empty: no breach is
% known. Declaring it says that much -- asking whether a breach is recorded is
% a question with an answer, and the answer is no. Leaving it undeclared would
% instead make the question an error, which is a different thing from silence.


% A demand is valid only if it falls within a granted power.
demand_validity(Subject, valid) :-
  demanded(authority, _, Subject, _),
  may_demand(authority, Subject).

demand_validity(Subject, invalid(outside_granted_power)) :-
  demanded(authority, _, Subject, _),
  \+ may_demand(authority, Subject).


% A missed deadline is a ground for termination only when the demand it
% attached to was one the authority could make. Against an invalid demand the
% silence carries nothing, whether or not the demand was later withdrawn --
% the withdrawal records the defect, it does not create it.
termination_ground(missed_deadline(Subject), available) :-
  demanded(authority, holder, Subject, Deadline),
  elapsed(Deadline),
  demand_validity(Subject, valid).

termination_ground(missed_deadline(Subject), unavailable(demand_was_invalid)) :-
  demanded(authority, holder, Subject, Deadline),
  elapsed(Deadline),
  demand_validity(Subject, invalid(_)).

% A breach of an actual condition would be a ground. None is recorded, and the
% absence of a record is not a breach, so this rule derives nothing here. It is
% written out so the proof shows which ground was looked for and not found.
termination_ground(breach(Condition), available) :-
  condition_of_status(Condition),
  breached(holder, Condition).


% Evidence handed over under a demand that could not be made does not become
% usable because it was handed over. The defect is in the asking, so it reaches
% everything the asking produced.
admissible(document(D), no(obtained_under_invalid_demand)) :-
  produced(holder, document(D), under(Subject)),
  demand_validity(Subject, invalid(_)).

admissible(document(D), yes) :-
  produced(holder, document(D), under(Subject)),
  demand_validity(Subject, valid).


% The status stands unless some ground for ending it is available.
holder_status(status, retained) :-
  \+ available_ground.

holder_status(status, terminated) :-
  available_ground.

available_ground :-
  termination_ground(_, available).
