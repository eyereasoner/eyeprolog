:- table path/2.

% EyeProlog language-identity example.
%
% This file intentionally uses the modern EyeProlog surface syntax:
%   - `.pl` source files instead of Prolog `.pl` files
%   - ISO Prolog-style uppercase variables
%   - explicit `table/1` declarations for tabled predicates
%   - quoted angle-bracket atoms for web-shaped identifiers

%% ?- path(X0, X1).

edge('<urn:example:a>', '<urn:example:b>').
edge('<urn:example:b>', '<urn:example:c>').
edge('<urn:example:c>', '<urn:example:d>').

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
