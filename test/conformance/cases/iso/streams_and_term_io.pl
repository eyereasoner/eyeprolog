% ISO 8.11-8.12: stream lifecycle, text/binary units, term I/O, and properties.
%% ?- text_roundtrip(Term, Peek, Code, Mode, Alias).

text_roundtrip(Term, Peek, Code, Mode, Alias) :-
    open('/tmp/eyeprolog-iso-text.txt', write, Output, [alias(iso_text_output), type(text)]),
    writeq(iso_text_output, sample(42)),
    put_char(iso_text_output, '.'),
    put_char(iso_text_output, ' '),
    close(Output),
    open('/tmp/eyeprolog-iso-text.txt', read, Input, [alias(iso_text_input), eof_action(eof_code)]),
    stream_property(Input, mode(Mode)),
    stream_property(Input, alias(Alias)),
    read(iso_text_input, Term),
    peek_char(Input, Peek),
    get_code(Input, Code),
    at_end_of_stream(Input),
    close(Input).

%% ?- binary_roundtrip(Peek, Byte, End).

binary_roundtrip(Peek, Byte, End) :-
    open('/tmp/eyeprolog-iso-binary.bin', write, Output, [type(binary)]),
    put_byte(Output, 65),
    close(Output),
    open('/tmp/eyeprolog-iso-binary.bin', read, Input, [type(binary), eof_action(eof_code)]),
    peek_byte(Input, Peek),
    get_byte(Input, Byte),
    get_byte(Input, End),
    close(Input).

%% ?- read_term_metadata(ok).

read_term_metadata(ok) :-
    open('/tmp/eyeprolog-iso-read-term.txt', write, Output, []),
    writeq(Output, pair(X, X, Y)),
    put_char(Output, '.'),
    close(Output),
    open('/tmp/eyeprolog-iso-read-term.txt', read, Input, [reposition(true)]),
    read_term(Input, pair(A, A, B), [
        variables([A, B]),
        variable_names([NameA=A, NameB=B]),
        singletons([NameB=B])
    ]),
    stream_property(Input, position(Position)),
    set_stream_position(Input, 0),
    read(Input, pair(C, C, D)),
    Position > 0,
    atom(NameA),
    atom(NameB),
    NameA \== NameB,
    C \== D,
    close(Input).

%% ?- default_streams(ok).

default_streams(ok) :-
    current_input(Input),
    current_output(Output),
    stream_property(Input, alias(user_input)),
    stream_property(Output, alias(user_output)),
    flush_output(Output).

%% ?- standard_write(ok).

standard_write(ok) :-
    write(io_marker),
    nl.

%% ?- numeric_escape_term_input(ok).

numeric_escape_term_input(ok) :-
    open('/tmp/eyeprolog-iso-read-escapes.txt', write, Output, []),
    put_code(Output, 39), put_code(Output, 92), put_code(Output, 55),
    put_code(Output, 92), put_code(Output, 39), put_code(Output, 46), nl(Output),
    put_code(Output, 39), put_code(Output, 92), put_code(Output, 120), put_code(Output, 55),
    put_code(Output, 92), put_code(Output, 39), put_code(Output, 46), nl(Output),
    close(Output),
    current_input(Old),
    open('/tmp/eyeprolog-iso-read-escapes.txt', read, Input, []),
    set_input(Input),
    read(A),
    read_term(B, []),
    set_input(Old),
    close(Input),
    A == '\a',
    B == '\a'.


%% ?- malformed_quoted_term_input(ok).

malformed_quoted_term_input(ok) :-
    open('/tmp/eyeprolog-iso-bad-quoted-term.txt', write, Output, []),
    put_code(Output, 39), nl(Output),
    close(Output),
    open('/tmp/eyeprolog-iso-bad-quoted-term.txt', read, Input, []),
    catch(read(Input, _), error(syntax_error(read_term), _), Caught = yes),
    close(Input),
    Caught == yes.
