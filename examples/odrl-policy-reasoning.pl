% ODRL-style policy reasoning in plain EyeProlog.
%
% This executable example models the reasoning layer rather than JSON-LD
% parsing.  It covers ODRL 2.2 permissions, prohibitions, constraints, duties,
% the perm/prohibit/invalid conflict strategies, action dependencies, and
% subsumption questions.  The final section shows how an ODRL profile with
% recursive defaults can use tnot/1: WFS keeps a negative cycle undefined
% instead of choosing an arbitrary permission or prohibition.
%
% References: https://www.w3.org/TR/odrl-model/#conflict
%             https://w3c.github.io/odrl/formal-semantics/

%% ?- actionQuestion(X0, X1, X2, X3).
%% ?- ruleQuestion(X0, X1, X2, X3).
%% ?- enforcementQuestion(X0, X1, X2, X3, X4, X5).
%% ?- conflictQuestion(X0, X1, X2, X3, X4).
%% ?- subsumptionQuestion(X0, X1, X2, X3).
%% ?- wfsQuestion(X0, X1).

% --- ODRL action vocabulary -----------------------------------------------

% A small excerpt of the ODRL action hierarchy.  broader(A, B) means that A
% is the more general action.  For example, a rule about use can affect print.
action(use).
action(present).
action(display).
action(play).
action(print).
action(distribute).
action(reproduce).
action(aggregate).
action(extract).
action(read).
action(delete).

broader(use, present).
broader(present, display).
broader(present, play).
broader(use, print).
broader(use, distribute).
broader(use, reproduce).

% Implicit action dependencies are kept separate from explicit subsumption.
requires(aggregate, read).
requires(extract, read).

action_subsumes(Action, Action) :- action(Action).
action_subsumes(Broader, Narrower) :- broader(Broader, Narrower).
action_subsumes(Broader, Narrower) :-
  broader(Broader, Middle),
  action_subsumes(Middle, Narrower).

action_requires(Action, Required) :- requires(Action, Required).
action_requires(Action, Required) :-
  requires(Action, Middle),
  action_requires(Middle, Required).

% The six useful answers to "how does this rule action relate to the requested
% action?": exact, broader, narrower, required, requiring, or no_match.
positive_action_match(Action, Action, exact) :- action(Action).
positive_action_match(RuleAction, RequestAction, broader) :-
  RuleAction \= RequestAction,
  action_subsumes(RuleAction, RequestAction).
positive_action_match(RuleAction, RequestAction, narrower) :-
  RuleAction \= RequestAction,
  action_subsumes(RequestAction, RuleAction).
positive_action_match(RuleAction, RequestAction, required) :-
  action_requires(RequestAction, RuleAction).
positive_action_match(RuleAction, RequestAction, requiring) :-
  action_requires(RuleAction, RequestAction).

action_match(RuleAction, RequestAction, Kind) :-
  positive_action_match(RuleAction, RequestAction, Kind).
action_match(RuleAction, RequestAction, no_match) :-
  action(RuleAction),
  action(RequestAction),
  \+ positive_action_match(RuleAction, RequestAction, _).

% --- Parties and assets ----------------------------------------------------

party(alice).
party(bob).
party(analysts).
party(anyone).
member_of(alice, analysts).
member_of(bob, analysts).

party_subsumes(Party, Party) :- party(Party).
party_subsumes(Group, Person) :- member_of(Person, Group).
party_subsumes(anyone, Party) :- party(Party), Party \= anyone.

asset(report_q1).
asset(report_q2).
asset(reports).
asset(dataset_a).
asset(dataset_b).
asset(dataset_c).

asset_member(report_q1, reports).
asset_member(report_q2, reports).

asset_subsumes(Asset, Asset) :- asset(Asset).
asset_subsumes(Collection, Item) :- asset_member(Item, Collection).

% --- Policies, rules, requests, and evidence ------------------------------

% policy(Policy, ConflictStrategy).
policy(open_printing, perm).
policy(strict_printing, prohibit).
policy(invalid_printing, invalid).
policy(duty_policy, invalid).
policy(context_policy, invalid).
policy(analysis_policy, invalid).
policy(general_policy, invalid).
policy(specific_policy, invalid).

% permission/prohibition(Policy, Rule, Assignee, Action, Target).
permission(open_printing, open_use, analysts, use, reports).
prohibition(open_printing, open_no_print, alice, print, report_q1).

permission(strict_printing, strict_use, analysts, use, reports).
prohibition(strict_printing, strict_no_print, alice, print, report_q1).

permission(invalid_printing, invalid_use, analysts, use, reports).
prohibition(invalid_printing, invalid_no_print, alice, print, report_q1).

permission(duty_policy, share_report, alice, distribute, report_q1).
duty(share_report, attribute_source).

permission(context_policy, research_use, analysts, use, reports).
constraint(research_use, purpose, research).

% Three independent static conflicts: exact action, explicit action
% subsumption, and an implicit requires dependency.
permission(analysis_policy, exact_permit, alice, display, dataset_a).
prohibition(analysis_policy, exact_prohibit, alice, display, dataset_a).
permission(analysis_policy, broad_permit, alice, use, dataset_b).
prohibition(analysis_policy, narrow_prohibit, alice, print, dataset_b).
permission(analysis_policy, aggregate_permit, alice, aggregate, dataset_c).
prohibition(analysis_policy, read_prohibit, alice, read, dataset_c).

% A broad policy and a narrower policy for rule/policy subsumption questions.
permission(general_policy, general_use, analysts, use, reports).
permission(specific_policy, specific_display, alice, display, report_q1).
constraint(specific_display, purpose, research).

% request(Request, Assignee, Action, Target).
request(q_print, alice, print, report_q1).
request(q_share_done, alice, distribute, report_q1).
request(q_share_missing, alice, distribute, report_q1).
request(q_research, alice, display, report_q1).
request(q_commercial, alice, display, report_q1).
request(q_unrelated, alice, delete, report_q1).

evidence(q_research, purpose, research).
evidence(q_commercial, purpose, commercial).
duty_done(q_share_done, attribute_source).

rule(Rule, Policy, permission, Party, Action, Target) :-
  permission(Policy, Rule, Party, Action, Target).
rule(Rule, Policy, prohibition, Party, Action, Target) :-
  prohibition(Policy, Rule, Party, Action, Target).

% --- Rule evaluation -------------------------------------------------------

rule_scope_matches(Rule, Request) :-
  rule(Rule, _, _, RuleParty, RuleAction, RuleTarget),
  request(Request, Party, Action, Target),
  party_subsumes(RuleParty, Party),
  asset_subsumes(RuleTarget, Target),
  positive_action_match(RuleAction, Action, _).

constraints_hold(Rule, Request) :-
  \+ (constraint(Rule, Key, Value), \+ evidence(Request, Key, Value)).

duties_hold(Rule, Request) :-
  \+ (duty(Rule, Duty), \+ duty_done(Request, Duty)).

permission_result(Rule, Request, permission) :-
  permission(_, Rule, _, _, _),
  rule_scope_matches(Rule, Request),
  constraints_hold(Rule, Request),
  duties_hold(Rule, Request).
permission_result(Rule, Request, inactive(constraint(Key))) :-
  permission(_, Rule, _, _, _),
  rule_scope_matches(Rule, Request),
  constraint(Rule, Key, Value),
  \+ evidence(Request, Key, Value).
permission_result(Rule, Request, inactive(duty(Duty))) :-
  permission(_, Rule, _, _, _),
  rule_scope_matches(Rule, Request),
  constraints_hold(Rule, Request),
  duty(Rule, Duty),
  \+ duty_done(Request, Duty).
permission_result(Rule, Request, not_applicable) :-
  permission(_, Rule, _, _, _),
  \+ rule_scope_matches(Rule, Request).

prohibition_result(Rule, Request, prohibition) :-
  prohibition(_, Rule, _, _, _),
  rule_scope_matches(Rule, Request),
  constraints_hold(Rule, Request).
prohibition_result(Rule, Request, inactive(constraint(Key))) :-
  prohibition(_, Rule, _, _, _),
  rule_scope_matches(Rule, Request),
  constraint(Rule, Key, Value),
  \+ evidence(Request, Key, Value).
prohibition_result(Rule, Request, not_applicable) :-
  prohibition(_, Rule, _, _, _),
  \+ rule_scope_matches(Rule, Request).

rule_result(Rule, Request, Result) :- permission_result(Rule, Request, Result).
rule_result(Rule, Request, Result) :- prohibition_result(Rule, Request, Result).

% --- Enforcement -----------------------------------------------------------

policy_permission(Policy, Request) :-
  permission(Policy, Rule, _, _, _),
  permission_result(Rule, Request, permission).
policy_prohibition(Policy, Request) :-
  prohibition(Policy, Rule, _, _, _),
  prohibition_result(Rule, Request, prohibition).
policy_inactive(Policy, Request) :-
  rule(Rule, Policy, _, _, _, _),
  rule_result(Rule, Request, inactive(_)).
policy_applicable(Policy, Request) :-
  rule(Rule, Policy, _, _, _, _),
  rule_scope_matches(Rule, Request).

% Conflicting permission/prohibition answers use the ODRL conflict strategy.
policy_result(Policy, Request, permission) :-
  policy_permission(Policy, Request),
  policy_prohibition(Policy, Request),
  policy(Policy, perm).
policy_result(Policy, Request, prohibition) :-
  policy_permission(Policy, Request),
  policy_prohibition(Policy, Request),
  policy(Policy, prohibit).
policy_result(Policy, Request, invalid) :-
  policy_permission(Policy, Request),
  policy_prohibition(Policy, Request),
  policy(Policy, invalid).

% Non-conflicting active rules retain their deontic result.
policy_result(Policy, Request, permission) :-
  policy_permission(Policy, Request),
  \+ policy_prohibition(Policy, Request).
policy_result(Policy, Request, prohibition) :-
  policy_prohibition(Policy, Request),
  \+ policy_permission(Policy, Request).
policy_result(Policy, Request, inactive) :-
  \+ policy_permission(Policy, Request),
  \+ policy_prohibition(Policy, Request),
  policy_inactive(Policy, Request).
policy_result(Policy, Request, not_applicable) :-
  policy(Policy, _),
  \+ policy_applicable(Policy, Request).

% Access-control enforcement adds the evaluator behaviour for the case where
% no rule applies.  "default" is the ODRL evaluator's closed behaviour.
access_decision(Policy, Request, _Behaviour, permit) :-
  policy_result(Policy, Request, permission).
access_decision(Policy, Request, _Behaviour, deny) :-
  policy_result(Policy, Request, prohibition).
access_decision(Policy, Request, _Behaviour, invalid) :-
  policy_result(Policy, Request, invalid).
access_decision(Policy, Request, _Behaviour, deny) :-
  policy_result(Policy, Request, inactive).
access_decision(Policy, Request, open, permit) :-
  policy_result(Policy, Request, not_applicable).
access_decision(Policy, Request, closed, deny) :-
  policy_result(Policy, Request, not_applicable).
access_decision(Policy, Request, default, deny) :-
  policy_result(Policy, Request, not_applicable).

% --- Static conflict detection --------------------------------------------

opposite(permission, prohibition).
opposite(prohibition, permission).

parties_overlap(A, B) :- party_subsumes(A, B).
parties_overlap(A, B) :- party_subsumes(B, A).
assets_overlap(A, B) :- asset_subsumes(A, B).
assets_overlap(A, B) :- asset_subsumes(B, A).
constraints_compatible(RuleA, RuleB) :-
  \+ (constraint(RuleA, Key, A), constraint(RuleB, Key, B), A \= B).

conflicting_action(Action, Action, exact) :- action(Action).
conflicting_action(ActionA, ActionB, subsumption) :-
  ActionA \= ActionB,
  (action_subsumes(ActionA, ActionB); action_subsumes(ActionB, ActionA)).
conflicting_action(ActionA, ActionB, dependency) :-
  \+ action_subsumes(ActionA, ActionB),
  \+ action_subsumes(ActionB, ActionA),
  (action_requires(ActionA, ActionB); action_requires(ActionB, ActionA)).

rule_conflict(RuleA, RuleB, Kind) :-
  rule(RuleA, _, EffectA, PartyA, ActionA, TargetA),
  rule(RuleB, _, EffectB, PartyB, ActionB, TargetB),
  opposite(EffectA, EffectB),
  parties_overlap(PartyA, PartyB),
  assets_overlap(TargetA, TargetB),
  constraints_compatible(RuleA, RuleB),
  conflicting_action(ActionA, ActionB, Kind).

% --- Rule and policy subsumption ------------------------------------------

constraints_subsume(General, Specific) :-
  \+ (constraint(General, Key, Value), \+ constraint(Specific, Key, Value)).
duties_subsume(General, Specific) :-
  \+ (duty(General, Duty), \+ duty(Specific, Duty)).

rule_subsumes(General, Specific) :-
  rule(General, _, Effect, GeneralParty, GeneralAction, GeneralTarget),
  rule(Specific, _, Effect, SpecificParty, SpecificAction, SpecificTarget),
  party_subsumes(GeneralParty, SpecificParty),
  action_subsumes(GeneralAction, SpecificAction),
  asset_subsumes(GeneralTarget, SpecificTarget),
  constraints_subsume(General, Specific),
  duties_subsume(General, Specific).

policy_subsumes(General, Specific) :-
  policy(General, _),
  policy(Specific, _),
  \+ (rule(SpecificRule, Specific, _, _, _, _),
      \+ (rule(GeneralRule, General, _, _, _, _),
          rule_subsumes(GeneralRule, SpecificRule))).

% --- WFS: true, false, and undefined --------------------------------------

% A profile can add recursive default rules.  clear is unconditionally allowed,
% denied has no permission, and cycle has mutually defaulted permission and
% prohibition.  The last case is intentionally undefined under WFS.
profile_request(clear).
profile_request(denied).
profile_request(cycle).
cycle_request(cycle).

profile_permission(clear).
profile_permission(Request) :-
  cycle_request(Request),
  tnot(profile_prohibition(Request)).
profile_prohibition(denied).
profile_prohibition(Request) :-
  cycle_request(Request),
  tnot(profile_permission(Request)).

% The normal-profile wfs_truth/2 predicate reports the three-valued result of
% each ground claim without treating an undefined claim as ordinary success.

% --- Curated questions -----------------------------------------------------

% All six action relationship outcomes used by the evaluator.
actionQuestion(exact, use, use, Kind) :- action_match(use, use, Kind).
actionQuestion(broader, use, print, Kind) :- action_match(use, print, Kind).
actionQuestion(narrower, print, use, Kind) :- action_match(print, use, Kind).
actionQuestion(required, read, aggregate, Kind) :- action_match(read, aggregate, Kind).
actionQuestion(requiring, aggregate, read, Kind) :- action_match(aggregate, read, Kind).
actionQuestion(unrelated, display, delete, Kind) :- action_match(display, delete, Kind).

% Rule-level evaluation shows active permission/prohibition, inactive rules
% caused by a failed condition or constraint, and non-applicability.
ruleQuestion(unconditional, open_use, q_print, Result) :- rule_result(open_use, q_print, Result).
ruleQuestion(duty_satisfied, share_report, q_share_done, Result) :- rule_result(share_report, q_share_done, Result).
ruleQuestion(duty_missing, share_report, q_share_missing, Result) :- rule_result(share_report, q_share_missing, Result).
ruleQuestion(constraint_true, research_use, q_research, Result) :- rule_result(research_use, q_research, Result).
ruleQuestion(constraint_false, research_use, q_commercial, Result) :- rule_result(research_use, q_commercial, Result).
ruleQuestion(scope_miss, research_use, q_unrelated, Result) :- rule_result(research_use, q_unrelated, Result).
ruleQuestion(prohibition, open_no_print, q_print, Result) :- rule_result(open_no_print, q_print, Result).

% The same conflicting request under all three ODRL conflict strategies, then
% duty/constraint failures and open-vs-closed handling when no rule applies.
enforcementQuestion(permission_overrides, open_printing, q_print, closed, Result, Decision) :-
  policy_result(open_printing, q_print, Result), access_decision(open_printing, q_print, closed, Decision).
enforcementQuestion(prohibition_overrides, strict_printing, q_print, closed, Result, Decision) :-
  policy_result(strict_printing, q_print, Result), access_decision(strict_printing, q_print, closed, Decision).
enforcementQuestion(conflict_invalidates, invalid_printing, q_print, closed, Result, Decision) :-
  policy_result(invalid_printing, q_print, Result), access_decision(invalid_printing, q_print, closed, Decision).
enforcementQuestion(duty_satisfied, duty_policy, q_share_done, closed, Result, Decision) :-
  policy_result(duty_policy, q_share_done, Result), access_decision(duty_policy, q_share_done, closed, Decision).
enforcementQuestion(duty_missing, duty_policy, q_share_missing, closed, Result, Decision) :-
  policy_result(duty_policy, q_share_missing, Result), access_decision(duty_policy, q_share_missing, closed, Decision).
enforcementQuestion(constraint_false, context_policy, q_commercial, closed, Result, Decision) :-
  policy_result(context_policy, q_commercial, Result), access_decision(context_policy, q_commercial, closed, Decision).
enforcementQuestion(no_match_closed, context_policy, q_unrelated, closed, Result, Decision) :-
  policy_result(context_policy, q_unrelated, Result), access_decision(context_policy, q_unrelated, closed, Decision).
enforcementQuestion(no_match_open, context_policy, q_unrelated, open, Result, Decision) :-
  policy_result(context_policy, q_unrelated, Result), access_decision(context_policy, q_unrelated, open, Decision).
enforcementQuestion(no_match_default, context_policy, q_unrelated, default, Result, Decision) :-
  policy_result(context_policy, q_unrelated, Result), access_decision(context_policy, q_unrelated, default, Decision).

% Conflict analysis distinguishes equality, explicit action subsumption, and
% implicit requires dependencies.
conflictQuestion(exact, analysis_policy, exact_permit, exact_prohibit, Kind) :- rule_conflict(exact_permit, exact_prohibit, Kind).
conflictQuestion(subsumption, analysis_policy, broad_permit, narrow_prohibit, Kind) :- rule_conflict(broad_permit, narrow_prohibit, Kind).
conflictQuestion(dependency, analysis_policy, aggregate_permit, read_prohibit, Kind) :- rule_conflict(aggregate_permit, read_prohibit, Kind).

% Positive and negative action, rule, and whole-policy subsumption questions.
subsumptionQuestion(action_yes, use, display, yes) :- action_subsumes(use, display).
subsumptionQuestion(action_no, display, use, no) :- \+ action_subsumes(display, use).
subsumptionQuestion(rule_yes, general_use, specific_display, yes) :- rule_subsumes(general_use, specific_display).
subsumptionQuestion(rule_no, specific_display, general_use, no) :- \+ rule_subsumes(specific_display, general_use).
subsumptionQuestion(policy_yes, general_policy, specific_policy, yes) :- policy_subsumes(general_policy, specific_policy).
subsumptionQuestion(policy_no, specific_policy, general_policy, no) :- \+ policy_subsumes(specific_policy, general_policy).

wfsQuestion(clear_permission, State) :- wfs_truth(profile_permission(clear), State).
wfsQuestion(absent_permission, State) :- wfs_truth(profile_permission(denied), State).
wfsQuestion(negative_cycle, State) :- wfs_truth(profile_permission(cycle), State).
