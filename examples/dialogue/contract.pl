% A contract dispute, for eyeprolog --dialogue.
%
% The same case as examples/dialogical-reasoning.pl, written as an ordinary
% program instead of a rulebook for a hand-written dialogue engine. Run with
% --dialogue, each answer is defended against the checker as opponent:
%
%   eyeprolog --dialogue examples/dialogue/contract.pl
%
% Both contracts look valid: nothing shows a party was a minor, so the
% opponent grants it, and the absence stays an obligation. Give the opponent
% the parties' birth years and it counters:
%
%   eyeprolog --evidence examples/dialogue/evidence.pl examples/dialogue/contract.pl
%
% Ann was a minor, but she ratified c17 once she came of age, so the
% proponent defends c17 again with the opponent's own evidence. Dave was a
% minor and never ratified, so c18 is lost.

%% ?- valid(Contract).

offer(c17, bob, ann).
accepted(c17, ann).
consideration(c17).
signed(c17, 2025).
ratified(c17, ann, 2028).

offer(c18, eve, dave).
accepted(c18, dave).
consideration(c18).
signed(c18, 2024).

% What is known about the parties' ages is the opponent's to bring.
:- dynamic(born/2).

party(Contract, Seller) :- offer(Contract, Seller, _).
party(Contract, Buyer) :- offer(Contract, _, Buyer).

minor_party(Contract) :-
  party(Contract, Party),
  signed(Contract, Year),
  born(Party, Born),
  Year - Born < 18.

ratified_at_majority(Contract) :-
  ratified(Contract, Party, Year),
  born(Party, Born),
  Year - Born >= 18.

valid(Contract) :-
  offer(Contract, _, Buyer),
  accepted(Contract, Buyer),
  consideration(Contract),
  \+ minor_party(Contract).
valid(Contract) :-
  offer(Contract, _, Buyer),
  accepted(Contract, Buyer),
  consideration(Contract),
  ratified_at_majority(Contract).
