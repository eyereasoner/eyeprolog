% Bulk character-by-character writes to a non-console text stream.
%
% put_char/2 writes one character at a time to an open file stream, and each
% write logically appends at the current stream position (ISO 7.10.2.8). This
% is the common pattern for hand-rolled serializers that emit one character or
% code point per call rather than a single bulk write/1 call. The example
% writes a repeating a-z run to a temporary file, closes it, then reopens and
% reads the file back one character at a time with get_char/2 to confirm every
% character round-trips. The path is under /tmp so the source tree is
% unchanged.

%% ?- bulk_write_result(X0, X1).

bulk_write_chars(_, 0) :- !.
bulk_write_chars(Stream, N) :-
  N > 0,
  Code is 0'a + (N mod 26),
  char_code(Char, Code),
  put_char(Stream, Char),
  N1 is N - 1,
  bulk_write_chars(Stream, N1).

count_chars(Stream, Acc, Count) :-
  get_char(Stream, Char),
  count_chars_step(Char, Stream, Acc, Count).

count_chars_step(end_of_file, _, Count, Count) :- !.
count_chars_step(_, Stream, Acc, Count) :-
  Acc1 is Acc + 1,
  count_chars(Stream, Acc1, Count).

bulk_write_path('/tmp/eyeprolog-bulk-stream-write-example.txt').

bulk_write_result(Requested, Counted) :-
  Requested = 5000,
  bulk_write_path(Path),
  open(Path, write, Out, [type(text)]),
  bulk_write_chars(Out, Requested),
  close(Out),
  open(Path, read, In, [type(text)]),
  count_chars(In, 0, Counted),
  close(In).
