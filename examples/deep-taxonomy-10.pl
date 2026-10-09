% =============================================================================================================================
% Deep Taxonomy - depth 10 - expanded N3-style eyeprolog
%
% Adjacent rules form the deep-taxonomy chain. Each step derives
% the next taxonomy class together with two side labels.
% =============================================================================================================================

%% ?- a(ind, a2).


:- discontiguous(a/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% fact

a(ind, n0).

% terminal rule

% Derivation rules: each rule below contributes one logical step toward the displayed results.
holds_result(test, true) :- once(a(ind, a2)).
a(X, a2) :- a(X, n10).

% Adjacent N3-style taxonomy rules.

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
a(X, n2) :- a(X, n1).
a(X, i2) :- a(X, n1).
a(X, j2) :- a(X, n1).
a(X, n3) :- a(X, n2).
a(X, i3) :- a(X, n2).
a(X, j3) :- a(X, n2).
a(X, n4) :- a(X, n3).
a(X, i4) :- a(X, n3).
a(X, j4) :- a(X, n3).
a(X, n5) :- a(X, n4).
a(X, i5) :- a(X, n4).
a(X, j5) :- a(X, n4).
a(X, n6) :- a(X, n5).
a(X, i6) :- a(X, n5).
a(X, j6) :- a(X, n5).
a(X, n7) :- a(X, n6).
a(X, i7) :- a(X, n6).
a(X, j7) :- a(X, n6).
a(X, n8) :- a(X, n7).
a(X, i8) :- a(X, n7).
a(X, j8) :- a(X, n7).
a(X, n9) :- a(X, n8).
a(X, i9) :- a(X, n8).
a(X, j9) :- a(X, n8).
a(X, n10) :- a(X, n9).
a(X, i10) :- a(X, n9).
a(X, j10) :- a(X, n9).
