% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = terminal_only, 'X1' = yes]).
answer(1, ['X0' = full_sentence, 'X1' = yes]).
answer(1, ['X0' = trailing_word, 'X1' = no]).
answer(1, ['X0' = intransitive, 'X1' = yes]).
answer(1, ['X0' = remainder, 'X1' = [scares, the, boy]]).
answer(1,
       ['X0' = first_generated,
        'X1' = [[the, boy, likes], [the, boy, scares], [the, boy, likes, the, boy], [the, boy, likes, the, girl]]]).
