% Dialogical reasoning: a claim is defended against an opponent, move by move.
%
% A proof can be read as one side of an argument. In the dialogue logic of
% Lorenzen and Lorenz, a proponent asserts a claim and an opponent may
% challenge every assertion that is not common ground. The proponent answers
% a challenge by naming a rule whose premises lead to the claim, and each
% premise is open to challenge in turn. The proponent wins when every
% challenge has been answered, and a claim holds exactly when the proponent
% can always win: a winning strategy is a proof.
%
% EyeProlog's proofs and proof checks already have this shape:
%
%   dialogue move                     proof and check
%   --------------------------------  ---------------------------------------
%   the opponent asks why(G)          C4: every use needs a justification
%   the proponent answers because     step(G, rule(N), Bindings, Uses)
%   the opponent concedes G           step(G, fact(N), [], [])
%   the opponent verifies a test      C5: a builtin is decided again
%   the opponent grants an absence    obligation(absent, ...)
%   the opponent counters an absence  C6: an absence is refuted by evidence
%
% What a dialogue adds is the opponent's own evidence. A proof checker can
% only list an absence as an obligation; an opponent can discharge it, or
% bring the evidence that refutes it. The proponent may then use that
% evidence too: under the formal rule of dialogue logic, the proponent may
% assert an atomic statement once the opponent has asserted it.
%
% The case is a contract dispute in three rounds:
%   1. The proponent claims contract c17 is valid. The opponent has no evidence
%      about the parties' ages, so it grants that no party was a minor: the
%      proponent wins, but with an open obligation.
%   2. Same claim, but now the opponent brings Ann's birth year and shows she
%      was a minor when she signed. The proponent drops its first defence and
%      wins with a second one, built on the opponent's own evidence: Ann
%      ratified the contract once she came of age.
%   3. The proponent claims contract c18 is valid. Dave was a minor and never
%      ratified, so every defence fails and the proponent loses.
%
% The game is written out here as an ordinary program, so that every move can
% be read in Prolog. EyeProlog plays it for any program: `eyeprolog --dialogue`
% defends each answer with its proof against the checker, and `--evidence`
% gives the opponent evidence of its own. examples/dialogue/contract.pl is
% this case as a plain program for that.

%% ?- move(Round, N, Speaker, Act).

%% ?- outcome(Round, Claim, Result).

%% ?- obligation(Round, Absence).

% The case file: the common ground both sides accept without argument.
case_fact(offer(c17, bob, ann)).
case_fact(accepted(c17, ann)).
case_fact(consideration(c17)).
case_fact(signed(c17, 2025)).
case_fact(ratified(c17, ann, 2028)).

case_fact(offer(c18, eve, dave)).
case_fact(accepted(c18, dave)).
case_fact(consideration(c18)).
case_fact(signed(c18, 2024)).

% The rules both sides argue by. A premise not(G) says nothing shows G; a
% premise test(E) is a computation either side can redo.

rule(r1, valid(C), [offer(C, _, B), accepted(C, B), consideration(C), not(minor_party(C))]).
rule(r2, valid(C), [offer(C, _, B), accepted(C, B), consideration(C), ratified_at_majority(C)]).
rule(r3, minor_party(C), [party(C, P), signed(C, Year), born(P, Born), test(Year - Born < 18)]).
rule(r4, ratified_at_majority(C), [ratified(C, P, Year), born(P, Born), test(Year - Born >= 18)]).
rule(r5, party(C, Seller), [offer(C, Seller, _)]).
rule(r6, party(C, Buyer), [offer(C, _, Buyer)]).

% The rulebook's index: for each kind of assertion, the rules that can defend
% it, in the order they are tried. An assertion no rule concludes can only be
% common ground.
defences(valid/1, [r1, r2]).
defences(minor_party/1, [r3]).
defences(ratified_at_majority/1, [r4]).
defences(party/2, [r5, r6]).
defences(offer/3, []).
defences(accepted/2, []).
defences(consideration/1, []).
defences(signed/2, []).
defences(ratified/3, []).
defences(born/2, []).

% The rounds: a claim, and the evidence the opponent holds back until it can
% use it.
round(1, valid(c17)).
round(2, valid(c17)).
round(3, valid(c18)).

evidence(2, born(bob, 1980)).
evidence(2, born(ann, 2009)).
evidence(3, born(eve, 1975)).
evidence(3, born(dave, 2010)).

% The dialogue of a round: the proponent's claim, then the defence of it.
dialogue(Round, Claim, [proponent-claims(Claim)|Moves], Result) :-
  round(Round, Claim),
  defend(Claim, Round, [], _, Moves, Result).

% defend(Goal, Round, Granted0, Granted, Moves, Result)
%
% Granted is what the opponent has asserted so far: evidence it played can be
% used by the proponent from then on. Result is won or lost. The clauses
% exclude each other, so a dialogue has exactly one course.

% A computation: the opponent redoes it.
defend(test(Expression), _, Granted, Granted, [opponent-verifies(Expression)], won) :-
  call(Expression).
defend(test(Expression), _, Granted, Granted, [opponent-refutes(Expression)], lost) :-
  \+ call(Expression).

% An absence: the opponent counters it with its own argument if it has one,
% and otherwise grants it -- for lack of evidence, not because it was shown.
defend(not(Goal), Round, Granted0, Granted, [opponent-counters(not(Goal), Evidence)], lost) :-
  once(opponent_proves(Goal, Round, Evidence)),
  append(Granted0, Evidence, Granted).
defend(not(Goal), Round, Granted, Granted, [opponent-grants(not(Goal))], won) :-
  \+ opponent_proves(Goal, Round, _).

% Common ground is conceded; anything else is challenged.
defend(Goal, _, Granted, Granted, [opponent-concedes(Goal)], won) :-
  assertion(Goal),
  once(common_ground(Goal, Granted)).
defend(Goal, Round, Granted0, Granted, [opponent-why(Goal)|Moves], Result) :-
  assertion(Goal),
  \+ common_ground(Goal, Granted0),
  functor(Goal, Name, Arity),
  defences(Name/Arity, Ids),
  defend_by(Ids, Goal, Round, Granted0, Granted, Moves, Result).

assertion(Goal) :-
  Goal \= test(_),
  Goal \= not(_).

% An assertion the opponent cannot challenge: it is in the case file, or the
% opponent asserted it itself.
common_ground(Goal, _) :-
  case_fact(Goal).
common_ground(Goal, Granted) :-
  member(Goal, Granted).

% Try each defence in turn. A defence that loses is retracted, but what the
% opponent revealed against it stays on the record.
defend_by([], Goal, _, Granted, Granted, [proponent-gives_up(Goal)], lost).
defend_by([Id|Ids], Goal, Round, Granted0, Granted, Moves, Result) :-
  copy_term(Goal, Attempt),
  rule(Id, Attempt, Premises),
  defend_all(Premises, Round, Granted0, Granted1, PremiseMoves, Outcome),
  settle(Outcome, Id, Ids, Goal, Attempt, Premises, PremiseMoves, Round, Granted1, Granted, Moves, Result).

settle(won, Id, _, Goal, Goal, Premises, PremiseMoves, _, Granted, Granted,
       [proponent-because(Goal, Id, Premises)|PremiseMoves], won).
settle(lost, Id, Ids, Goal, Attempt, Premises, PremiseMoves, Round, Granted1, Granted, Moves, Result) :-
  append([proponent-because(Attempt, Id, Premises)|PremiseMoves], [proponent-retracts(Goal, Id)|Rest], Moves),
  defend_by(Ids, Goal, Round, Granted1, Granted, Rest, Result).

% Premises are defended left to right; the first lost premise loses the
% defence.
defend_all([], _, Granted, Granted, [], won).
defend_all([Premise|Premises], Round, Granted0, Granted, Moves, Result) :-
  defend(Premise, Round, Granted0, Granted1, PremiseMoves, Outcome),
  continue(Outcome, Premises, Round, Granted1, Granted, PremiseMoves, Moves, Result).

continue(won, Premises, Round, Granted0, Granted, PremiseMoves, Moves, Result) :-
  defend_all(Premises, Round, Granted0, Granted, Rest, Result),
  append(PremiseMoves, Rest, Moves).
continue(lost, _, _, Granted, Granted, Moves, Moves, lost).

% The opponent's own argument: the same rules, over the case file and the
% evidence it holds. Evidence lists the evidence the argument used.
opponent_proves(test(Expression), _, []) :-
  call(Expression).
opponent_proves(Goal, _, []) :-
  assertion(Goal),
  case_fact(Goal).
opponent_proves(Goal, Round, [Goal]) :-
  assertion(Goal),
  evidence(Round, Goal).
opponent_proves(Goal, Round, Evidence) :-
  assertion(Goal),
  rule(_, Goal, Premises),
  opponent_proves_all(Premises, Round, Evidence).

opponent_proves_all([], _, []).
opponent_proves_all([Premise|Premises], Round, Evidence) :-
  opponent_proves(Premise, Round, First),
  opponent_proves_all(Premises, Round, Rest),
  append(First, Rest, Evidence).

% The answers: each move numbered, how each round ended, and the absences a
% won round still rests on. A premise the proponent could not settle keeps
% its variables; they are named unknown(1), unknown(2), ... -- "someone
% ratified it, in some year".
move(Round, N, Speaker, Act) :-
  dialogue(Round, _, Moves, _),
  nth1(N, Moves, Speaker-Open),
  copy_term(Open, Act),
  term_variables(Act, Unknowns),
  name_unknowns(Unknowns, 1).

name_unknowns([], _).
name_unknowns([unknown(N)|Unknowns], N) :-
  Next is N + 1,
  name_unknowns(Unknowns, Next).

outcome(Round, Claim, Result) :-
  dialogue(Round, Claim, _, Result).

obligation(Round, not(Goal)) :-
  dialogue(Round, _, Moves, won),
  member(opponent-grants(not(Goal)), Moves).
