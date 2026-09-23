% ISO/IEC TS 13211-3:2025 grammar-body semantics regressions.
digit(D) --> [D], { member(D, [a,b]) }.

% phrase([], S0, S) is true iff S0 = S.
answer(empty_sequence, S) :- phrase([], [a,b], S).

% phrase((A,B), S0, S) iff phrase(A, S0, S1), phrase(B, S1, S).
answer(concatenation, S) :- phrase(([a], [b]), [a,b,c], S).

% phrase((A;B), S0, S) iff ( phrase(A,S0,S) ; phrase(B,S0,S) ).
answer(alternative, S) :- phrase(([a] ; [b]), [b,c], S).

% if-then-else regression examples.
answer(ite_13, yes) :- phrase((("1" | "2") -> "3" ; "4"), "13").
answer(ite_23, yes) :- phrase((("1" | "2") -> "3" ; "4"), "23").
answer(ite_4, yes) :- phrase((("1" | "2") -> "3" ; "4"), "4").
answer(ite_single, no) :- \+ phrase((("1" | "2") -> "3" ; "4"), [_]).

% phrase({G}, S0, S) is true iff ( G, S0 = S ).
answer(grammar_body_goal, S) :- phrase({true}, [a], S).

% phrase(phrase(NT), S0, S) iff phrase(NT, S0, S).
answer(phrase_nonterminal, S) :- phrase(phrase([a]), [a,b], S).

% phrase(!, S0, S) is true iff S0 = S.
answer(cut_identity, S) :- phrase(!, [a,b], S).

% phrase(\+ GRBody, S0, S) iff ( \+ phrase(GRBody, S0, _), S0 = S ).
answer(negation_identity, S) :- phrase(\+ [a], [b,c], S).
answer(negation_blocks, no) :- \+ phrase(\+ [a], [a], _).

% ('.')//2 separates a terminal from the rest of the sequence.
answer(terminal_split, D) :- phrase(digit(D), [b]).
%% ?- answer(X0, X1).
