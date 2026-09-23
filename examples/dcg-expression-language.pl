% Parse, evaluate, and regenerate arithmetic expressions with a DCG.
%
% The parser builds an AST while respecting precedence and left associativity.
% The additive_tail//2 and multiplicative_tail//2 nonterminals use an
% accumulator instead of left recursion.  A second DCG pretty-prints an AST
% with only the parentheses required to preserve its structure, making the
% example useful in both directions.
%% ?- dcg_expression_example(X0, X1).

% expression//1: + and - are the lowest-precedence operators.
expression(AST) -->
  term(First),
  additive_tail(First, AST).

additive_tail(Left, AST) -->
  ['+'],
  term(Right),
  { Next = add(Left, Right) },
  additive_tail(Next, AST).
additive_tail(Left, AST) -->
  ['-'],
  term(Right),
  { Next = sub(Left, Right) },
  additive_tail(Next, AST).
additive_tail(AST, AST) --> [].

% term//1: * and / bind more tightly than + and -.
term(AST) -->
  unary(First),
  multiplicative_tail(First, AST).

multiplicative_tail(Left, AST) -->
  ['*'],
  unary(Right),
  { Next = mul(Left, Right) },
  multiplicative_tail(Next, AST).
multiplicative_tail(Left, AST) -->
  ['/'],
  unary(Right),
  { Next = div(Left, Right) },
  multiplicative_tail(Next, AST).
multiplicative_tail(AST, AST) --> [].

% Unary minus nests, so --x is represented as neg(neg(var(x))).
unary(neg(AST)) --> ['-'], unary(AST).
unary(AST) --> primary(AST).

primary(lit(Number)) -->
  [Number],
  { number(Number) }.
primary(var(Name)) -->
  [Name],
  { variable_name(Name) }.
primary(AST) --> ['('], expression(AST), [')'].

variable_name(x).
variable_name(y).
variable_name(z).

% A small evaluator for the AST produced by the grammar.
evaluate(lit(Number), _, Number).
evaluate(var(Name), Environment, Value) :-
  lookup(Name, Environment, Value).
evaluate(neg(AST), Environment, Value) :-
  evaluate(AST, Environment, Inner),
  Value is -Inner.
evaluate(add(Left, Right), Environment, Value) :-
  evaluate(Left, Environment, L),
  evaluate(Right, Environment, R),
  Value is L + R.
evaluate(sub(Left, Right), Environment, Value) :-
  evaluate(Left, Environment, L),
  evaluate(Right, Environment, R),
  Value is L - R.
evaluate(mul(Left, Right), Environment, Value) :-
  evaluate(Left, Environment, L),
  evaluate(Right, Environment, R),
  Value is L * R.
evaluate(div(Left, Right), Environment, Value) :-
  evaluate(Left, Environment, L),
  evaluate(Right, Environment, R),
  Value is L / R.

lookup(Name, [Name-Value|_], Value).
lookup(Name, [_|Rest], Value) :-
  lookup(Name, Rest, Value).

% Precedence-aware generation.  The right operand is emitted at a stricter
% minimum precedence than the left operand, preserving left associativity.
emit_expression(AST) --> emit(AST, 0).

emit(AST, Minimum) -->
  { precedence(AST, Precedence),
    parenthesize(Precedence, Minimum, Wrap) },
  emit_wrapped(Wrap, AST).

emit_wrapped(yes, AST) --> ['('], emit_node(AST), [')'].
emit_wrapped(no, AST) --> emit_node(AST).

emit_node(lit(Number)) --> [Number].
emit_node(var(Name)) --> [Name].
emit_node(neg(AST)) --> ['-'], emit(AST, 30).
emit_node(add(Left, Right)) -->
  emit(Left, 10), ['+'], emit(Right, 11).
emit_node(sub(Left, Right)) -->
  emit(Left, 10), ['-'], emit(Right, 11).
emit_node(mul(Left, Right)) -->
  emit(Left, 20), ['*'], emit(Right, 21).
emit_node(div(Left, Right)) -->
  emit(Left, 20), ['/'], emit(Right, 21).

precedence(add(_, _), 10).
precedence(sub(_, _), 10).
precedence(mul(_, _), 20).
precedence(div(_, _), 20).
precedence(neg(_), 30).
precedence(lit(_), 40).
precedence(var(_), 40).

parenthesize(Precedence, Minimum, yes) :- Precedence < Minimum.
parenthesize(Precedence, Minimum, no) :- Precedence >= Minimum.

% Parse a mixed-precedence expression.
dcg_expression_example(parsed, AST) :-
  phrase(expression(AST),
         [2, '+', 3, '*', '(', 4, '-', 1, ')']).

% Evaluate a parsed expression with variables.
dcg_expression_example(evaluated, Value) :-
  phrase(expression(AST), [x, '*', '(', y, '+', 2, ')', '-', z]),
  evaluate(AST, [x-4, y-3, z-1], Value).

% Generate the minimal parentheses needed to preserve a right-nested
% subtraction tree, then parse the generated tokens back to the same AST.
dcg_expression_example(round_trip, Tokens) :-
  AST = sub(lit(20), sub(lit(5), lit(3))),
  phrase(emit_expression(AST), Tokens),
  phrase(expression(AST), Tokens).

% phrase/3 lets a larger language parse an expression prefix and keep the rest.
dcg_expression_example(remainder, Rest) :-
  phrase(expression(mul(var(x), lit(2))),
         [x, '*', 2, then, stop], Rest).

% Missing closing parentheses are rejected.
dcg_expression_example(rejected, malformed_parentheses) :-
  \+ phrase(expression(_), [2, '*', '(', 3, '+', 4]).
