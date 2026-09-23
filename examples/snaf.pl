% Alice loves Bob; Bob is a person. If Alice does not hate a person, conclude she hates Nobody.

%% ?- hates(alice, nobody).

% Facts
loves(alice, bob).
person(bob).

% Rule
hates(alice, nobody) :-
    person(X),
    \+ hates(alice, X).
