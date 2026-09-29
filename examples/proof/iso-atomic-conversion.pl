report(joined, eyeprolog).
report(prefix, eye).
report(characters, "eye").
report(codes, [65, 90]).
report(decoded_character, 'λ').
report(number, 42).
report(fragment, fragment(0, eye, 6)).
report(fragment, fragment(1, yep, 5)).
report(fragment, fragment(2, epr, 4)).
report(fragment, fragment(3, pro, 3)).
report(fragment, fragment(4, rol, 2)).
report(fragment, fragment(5, olo, 1)).
report(fragment, fragment(6, log, 0)).

clause(1, report(joined, var('Atom')), atom_concat(eye, prolog, var('Atom'))).
clause(2, report(prefix, var('Prefix')), atom_concat(var('Prefix'), prolog, eyeprolog)).
clause(3, report(characters, var('Chars')), atom_chars(eye, var('Chars'))).
clause(4, report(codes, var('Codes')), atom_codes('AZ', var('Codes'))).
clause(5, report(decoded_character, var('Char')), char_code(var('Char'), 955)).
clause(6, report(number, var('Number')), number_chars(var('Number'), "42")).
clause(7,
       report(fragment, fragment(var('Before'), var('Part'), var('After'))),
       sub_atom(eyeprolog, var('Before'), 3, var('After'), var('Part'))).

step(report(joined, eyeprolog),
     rule(1),
     ['Atom' = eyeprolog],
     [atom_concat(eye, prolog, eyeprolog)]).
step(atom_concat(eye, prolog, eyeprolog), builtin, [], []).
step(report(prefix, eye), rule(2), ['Prefix' = eye], [atom_concat(eye, prolog, eyeprolog)]).
step(report(characters, "eye"), rule(3), ['Chars' = "eye"], [atom_chars(eye, "eye")]).
step(atom_chars(eye, "eye"), builtin, [], []).
step(report(codes, [65, 90]), rule(4), ['Codes' = [65, 90]], [atom_codes('AZ', [65, 90])]).
step(atom_codes('AZ', [65, 90]), builtin, [], []).
step(report(decoded_character, 'λ'), rule(5), ['Char' = 'λ'], [char_code('λ', 955)]).
step(char_code('λ', 955), builtin, [], []).
step(report(number, 42), rule(6), ['Number' = 42], [number_chars(42, "42")]).
step(number_chars(42, "42"), builtin, [], []).
step(report(fragment, fragment(0, eye, 6)),
     rule(7),
     ['Before' = 0, 'Part' = eye, 'After' = 6],
     [sub_atom(eyeprolog, 0, 3, 6, eye)]).
step(sub_atom(eyeprolog, 0, 3, 6, eye), builtin, [], []).
step(report(fragment, fragment(1, yep, 5)),
     rule(7),
     ['Before' = 1, 'Part' = yep, 'After' = 5],
     [sub_atom(eyeprolog, 1, 3, 5, yep)]).
step(sub_atom(eyeprolog, 1, 3, 5, yep), builtin, [], []).
step(report(fragment, fragment(2, epr, 4)),
     rule(7),
     ['Before' = 2, 'Part' = epr, 'After' = 4],
     [sub_atom(eyeprolog, 2, 3, 4, epr)]).
step(sub_atom(eyeprolog, 2, 3, 4, epr), builtin, [], []).
step(report(fragment, fragment(3, pro, 3)),
     rule(7),
     ['Before' = 3, 'Part' = pro, 'After' = 3],
     [sub_atom(eyeprolog, 3, 3, 3, pro)]).
step(sub_atom(eyeprolog, 3, 3, 3, pro), builtin, [], []).
step(report(fragment, fragment(4, rol, 2)),
     rule(7),
     ['Before' = 4, 'Part' = rol, 'After' = 2],
     [sub_atom(eyeprolog, 4, 3, 2, rol)]).
step(sub_atom(eyeprolog, 4, 3, 2, rol), builtin, [], []).
step(report(fragment, fragment(5, olo, 1)),
     rule(7),
     ['Before' = 5, 'Part' = olo, 'After' = 1],
     [sub_atom(eyeprolog, 5, 3, 1, olo)]).
step(sub_atom(eyeprolog, 5, 3, 1, olo), builtin, [], []).
step(report(fragment, fragment(6, log, 0)),
     rule(7),
     ['Before' = 6, 'Part' = log, 'After' = 0],
     [sub_atom(eyeprolog, 6, 3, 0, log)]).
step(sub_atom(eyeprolog, 6, 3, 0, log), builtin, [], []).
