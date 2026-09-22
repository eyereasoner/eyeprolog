% Prolog result format 4
query(1, dcg_example(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = parsed, 'X1' = set(light(kitchen), on)]).
why(1,
    ['X0' = parsed, 'X1' = set(light(kitchen), on)],
    [dcg_example(parsed, set(light(kitchen), on))]).
answer(1, ['X0' = generated, 'X1' = [set, hall, light, to, off]]).
why(1,
    ['X0' = generated, 'X1' = [set, hall, light, to, off]],
    [dcg_example(generated, [set, hall, light, to, off])]).
answer(1, ['X0' = remainder, 'X1' = [then, wait]]).
why(1, ['X0' = remainder, 'X1' = [then, wait]], [dcg_example(remainder, [then, wait])]).
answer(1, ['X0' = rejected, 'X1' = invalid_command]).
why(1, ['X0' = rejected, 'X1' = invalid_command], [dcg_example(rejected, invalid_command)]).

clause(6,
       dcg_example(parsed, var('Command')),
       phrase(command(var('Command')), [set, kitchen, light, to, on])).
clause(7,
       dcg_example(generated, var('Tokens')),
       phrase(command(set(light(hall), off)), var('Tokens'))).
clause(8,
       dcg_example(remainder, var('Rest')),
       phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], var('Rest'))).
clause(9,
       dcg_example(rejected, invalid_command),
       \+ phrase(command(anonymous(1)), [set, garage, light, to, blinking])).

step(dcg_example(parsed, set(light(kitchen), on)),
     rule(6),
     ['Command' = set(light(kitchen), on)],
     [phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on])]).
step(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on]), builtin, [], []).
step(dcg_example(generated, [set, hall, light, to, off]),
     rule(7),
     ['Tokens' = [set, hall, light, to, off]],
     [phrase(command(set(light(hall), off)), [set, hall, light, to, off])]).
step(phrase(command(set(light(hall), off)), [set, hall, light, to, off]), builtin, [], []).
step(dcg_example(remainder, [then, wait]),
     rule(8),
     ['Rest' = [then, wait]],
     [phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait])]).
step(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait]),
     builtin,
     [],
     []).
step(dcg_example(rejected, invalid_command),
     rule(9),
     [],
     [\+ phrase(command(__anon0), [set, garage, light, to, blinking])]).
step(\+ phrase(command(__anon0), [set, garage, light, to, blinking]), absent, [], []).
