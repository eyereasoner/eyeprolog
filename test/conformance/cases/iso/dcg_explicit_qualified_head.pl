% An explicitly qualified grammar-rule head defines the expanded predicate
% in the named module even without a surrounding module declaration.

dcg_explicit:word --> [x].

%% ?- phrase(dcg_explicit:word, [x]).
