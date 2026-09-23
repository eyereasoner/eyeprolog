has_parent(alice, parent_of(alice)).
has_parent(bob, parent_of(bob)).
registration(alice, logic, registration_of(alice, logic)).
registration(alice, math, registration_of(alice, math)).
registration(bob, logic, registration_of(bob, logic)).
same_witness(parent_of_alice, true).
distinct_witnesses(alice_logic_vs_alice_math, true).
