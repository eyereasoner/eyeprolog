% Composition of injective functions is injective.
%
% A function is injective when no two distinct inputs share an output. The
% finite model below checks that property for f, g, and their composite
% h = g o f, and derives that the composite inherits it. A second composite
% h2 = g2 o f, built from a g2 that is not injective, shows that the premise
% matters: h2 has a collision, so no injectivity is derived for it.
%
% The output is:
% compositeInjective(h, g, f), and the collisions of g2 and h2.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% ?- compositeInjective(X0, X1, X2).

%% ?- collision(X0, X1, X2).


:- discontiguous(app/3).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
function(f).
function(g).
function(g2).
function(h).
function(h2).

% f maps a and b to distinct points; g and g2 map c and d onward.
app(f, a, c).
app(f, b, d).
app(g, c, e).
app(g, d, k).
app(g2, c, e).
app(g2, d, e).

compositeOf(h, g, f).
compositeOf(h2, g2, f).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
% The composite applies F first and then G.
app(H, X, Z) :-
  compositeOf(H, G, F),
  app(F, X, Y),
  app(G, Y, Z).

% A collision is a witness against injectivity: two distinct inputs, one output.
collision(F, X, Y) :-
  app(F, X, Z),
  app(F, Y, Z),
  (X \= Y).

% A function is injective in this finite model when it has no collision.
injective(F) :-
  function(F),
  \+ collision(F, _, _).

% The theorem instance: both parts are injective, and so is their composite.
compositeInjective(H, G, F) :-
  compositeOf(H, G, F),
  injective(G),
  injective(F),
  injective(H).
