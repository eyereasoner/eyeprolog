% Parse and generate commands for a tiny home-automation language with a DCG.
%
% The grammar separates surface tokens from the structured command term used
% by an application.  phrase/2 requires complete input, while phrase/3 leaves
% unconsumed tokens available to a surrounding parser.
%% ?- dcg_example(X0, X1).

command(set(light(Room), State)) -->
  [set], room(Room), [light, to], state(State).

room(kitchen) --> [kitchen].
room(hall) --> [hall].

state(on) --> [on].
state(off) --> [off].

dcg_example(parsed, Command) :-
  phrase(command(Command), [set, kitchen, light, to, on]).
dcg_example(generated, Tokens) :-
  phrase(command(set(light(hall), off)), Tokens).
dcg_example(remainder, Rest) :-
  phrase(command(set(light(kitchen), on)),
         [set, kitchen, light, to, on, then, wait],
         Rest).
dcg_example(rejected, invalid_command) :-
  \+ phrase(command(_), [set, garage, light, to, blinking]).
