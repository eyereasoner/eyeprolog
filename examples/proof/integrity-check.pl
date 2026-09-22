% Prolog result format 4
query(1, invalid_state(_0, _1), ['X' = _0, 'Reason' = _1]).
result(1, complete, 1).
answer(1, ['X' = stone, 'Reason' = conflicting_colors]).
why(1, ['X' = stone, 'Reason' = conflicting_colors], [invalid_state(stone, conflicting_colors)]).
query(2, status(_0, _1), ['X' = _0, 'Value' = _1]).
result(2, complete, 1).
answer(2, ['X' = stone, 'Value' = invalid(conflicting_colors)]).
why(2,
    ['X' = stone, 'Value' = invalid(conflicting_colors)],
    [status(stone, invalid(conflicting_colors))]).

clause(1, color(stone, black), true).
clause(2, color(stone, white), true).
clause(3,
       invalid_state(var('X'), conflicting_colors),
       (color(var('X'), black), color(var('X'), white))).
clause(4, status(var('X'), invalid(var('Reason'))), invalid_state(var('X'), var('Reason'))).

step(invalid_state(stone, conflicting_colors),
     rule(3),
     ['X' = stone],
     [color(stone, black), color(stone, white)]).
step(color(stone, black), fact(1), [], []).
step(color(stone, white), fact(2), [], []).
step(status(stone, invalid(conflicting_colors)),
     rule(4),
     ['X' = stone, 'Reason' = conflicting_colors],
     [invalid_state(stone, conflicting_colors)]).
