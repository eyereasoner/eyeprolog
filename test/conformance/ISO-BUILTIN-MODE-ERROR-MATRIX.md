# ISO Part 1 built-in mode/error review

This matrix turns the broad built-in review in `ISO-COMPLIANCE.md` into smaller,
release-gated units. The normative baseline is ISO/IEC 13211-1:1995 plus
Technical Corrigenda 1:2007, 2:2012, and 3:2017.

A `covered` row has executable evidence for the required successful mode,
failure behavior, or individual error condition. `not applicable` records a
conditional standard branch that cannot occur under EyeProlog's documented
processor choices. ISO 7.12 makes the reported error implementation dependent
when more than one error condition is simultaneously satisfied. Accordingly,
this matrix treats overlap tests as stable EyeProlog processor choices unless a
more specific procedural requirement or Corrigendum constrains the result; it
does not infer a universal priority merely from the textual order of an error
table.

The table is intentionally explicit about what has and has not been closed.
The current review now covers the complete 8.2-8.17 built-in family at the
level of prescribed modes, success/failure behavior, individual error
conditions, and explicit not-applicable processor branches. Closely related
conditions may share a row only when that row names every condition and the
executable evidence for each. Higher-level Clause 7 and Clause 9 semantics
remain tracked separately.

The focused assertions added for this matrix live in `test/run-iso-strict.mjs`;
existing file-based cases remain additional regression evidence.

## 8.2 — term unification

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.2.1 `(=)/2` | `?term, ?term`; succeeds/fails according to Prolog unification; no prescribed errors | covered | existing unification corpus and `term_modes_and_ordering` |
| 8.2.2 `unify_with_occurs_check/2` | `?term, ?term`; succeeds/fails and never reports a prescribed error | covered | strict row-review success assertion plus unification corpus |
| 8.2.3 `(\=)/2` | `@term, @term`; succeeds/fails for the defined NSTO cases; no prescribed errors | covered | unification/control corpus |
| Cor.2 8.2.4 `subsumes_term/2` | `@term, @term`; succeeds/fails without binding its arguments; no prescribed errors | covered | strict row-review success assertion and Corrigendum 2 term-predicate cases |

## 8.3 — type testing

All Part 1 type tests have a single input-term mode and no prescribed errors.
The Corrigendum 2 additions have the same shape.

| Predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| `var/1` | input term; semidet; no errors | covered | `type_var_success` and term-mode cases |
| `atom/1` | input term; semidet; no errors | covered | `type_atom_success` |
| `integer/1` | input term; semidet; no errors | covered | `type_integer_success` |
| `float/1` | input term; semidet; no errors | covered | `type_float_success` |
| `atomic/1` | input term; semidet; no errors | covered | `type_atomic_atom_success`, `type_atomic_number_success` |
| `compound/1` | input term; semidet; no errors | covered | `type_compound_success` |
| `nonvar/1` | input term; semidet; no errors | covered | `type_nonvar_success` |
| `number/1` | input term; semidet; no errors | covered | `type_number_integer_success`, `type_number_float_success` |
| Cor.2 `callable/1` | input term; semidet; no errors | covered | `type_callable_atom_success`, `type_callable_compound_success` |
| Cor.2 `ground/1` | input term; semidet; no errors | covered | `type_ground_success` |
| Cor.2 `acyclic_term/1` | input term; semidet; no errors | covered | Corrigendum 2 term-predicate coverage |

## 8.4 — term comparison and sorting

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.4.1 `(@<)/2` | two input terms; semidet; no prescribed errors | covered | standard-order corpus and strict type/collation ordering assertions |
| 8.4.1 `(@=<)/2` | two input terms; semidet; no prescribed errors | covered | standard-order corpus |
| 8.4.1 `(==)/2` | two input terms; identity test; no prescribed errors | covered | identity/term-mode corpus |
| 8.4.1 `(\==)/2` | two input terms; non-identity test; no prescribed errors | covered | identity/term-mode corpus |
| 8.4.1 `(@>)/2` | two input terms; semidet; no prescribed errors | covered | standard-order corpus |
| 8.4.1 `(@>=)/2` | two input terms; semidet; no prescribed errors | covered | standard-order corpus |
| Cor.2 8.4.2 `compare/3` | output-order mode | covered | strict `compare(<,a,b)` / comparison cases |
| Cor.2 8.4.2 `compare/3` | input-order mode | covered | comparison cases |
| Cor.2 8.4.2 error (a) | non-variable, non-atom `Order` -> atom type error | covered | strict `compare(1,3,3.0)` |
| Cor.2 8.4.2 error (b) | atom outside `<`, `=`, `>` -> order domain error | covered | strict `compare(>=,3,3.0)` |
| Cor.2 8.4.3 `sort/2` | input list -> output list | covered | strict `sort([1,1],[1])` and sorting corpus |
| Cor.2 8.4.3 `sort/2` | input list + input result list | covered | sorting corpus |
| Cor.2 8.4.3 error (a) | partial input list -> instantiation error | covered | strict `sort([1|T],_)` |
| Cor.2 8.4.3 error (b) | non-list input -> list type error | covered | strict `sort(foo,_)` |
| Cor.2 8.4.3 error (c) | non-list result -> list type error | covered | strict `sort([],foo)` |
| Cor.2 8.4.4 `keysort/2` | input pairs -> output list | covered | strict `keysort([2-b,1-a],[1-a,2-b])` and Corrigendum cases |
| Cor.2 8.4.4 `keysort/2` | input pairs + input result list | covered | Corrigendum cases |
| Cor.2 8.4.4 error (a) | partial `Pairs` -> instantiation error | covered | strict `keysort([1-a|T],_)` |
| Cor.2 8.4.4 error (b) | non-list `Pairs` -> list type error | covered | strict `keysort(foo,_)` |
| Cor.2 8.4.4 error (c) | non-list `Sorted` -> list type error | covered | strict `keysort([],foo)` |
| Cor.2 8.4.4 error (d) | variable element in `Pairs` prefix -> instantiation error | covered | strict `keysort([X],_)` |
| Cor.2 8.4.4 error (e) | non-pair element in `Pairs` prefix -> pair type error | covered | strict `keysort([foo],_)` |
| Cor.2 8.4.4 error (f) | non-pair element in `Sorted` prefix -> pair type error | covered | strict `keysort([],[foo])` |

## 8.5 — term creation and decomposition

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.5.1 `functor/3` | decompose a non-variable term | covered | term-construction corpus |
| 8.5.1 `functor/3` | construct from `Name` and `Arity` | covered | term-construction corpus |
| 8.5.1 errors (a-b) | missing required `Name` or `Arity` when constructing -> instantiation error | covered | strict `functor(X,Y,3)` and `functor(X,foo,N)` |
| 8.5.1 error (c) | non-atomic `Name` -> atomic type error | covered | strict `functor(X,foo(a),a)` precedence case |
| 8.5.1 error (d) | non-integer `Arity` -> integer type error | covered | strict `functor(X,foo,a)` |
| 8.5.1 error (e) | positive arity with non-atom atomic name -> atom type error | covered | strict `functor(X,1.5,1)` |
| 8.5.1 error (f) | requested arity above finite `max_arity` | not applicable | EyeProlog selects `max_arity=unbounded`; finite host exhaustion is a resource condition |
| 8.5.1 error (g) | negative `Arity` -> non-negative domain error | covered | strict `functor(X,foo,-1)` |
| 8.5.2 `arg/3` | positive integer index + compound term | covered | `logtalk_arg_unification` and strict cases |
| 8.5.2 error (a) | variable index -> instantiation error | covered | strict `arg(X,foo(a),_)` |
| 8.5.2 error (b) | variable term -> instantiation error | covered | strict `arg(1,X,_)` |
| 8.5.2 error (c) | non-integer index -> integer type error | covered | strict `arg(a,foo(a),_)` |
| 8.5.2 error (d) | non-compound term -> compound type error | covered | strict `arg(0,atom,_)` precedence case |
| 8.5.2 error (e) | negative index -> non-negative domain error | covered | strict `arg(-1,foo(a),_)` |
| 8.5.3 `(=..)/2` | term -> list decomposition | covered | `logtalk_univ` and term-construction cases |
| 8.5.3 `(=..)/2` | list -> term construction | covered | `logtalk_univ` and term-construction cases |
| 8.5.3 error (a) | both arguments insufficiently instantiated | covered | strict `X=..Y` |
| 8.5.3 error (b) | partial list in construction direction | covered | strict `X=..[foo|T]` |
| 8.5.3 error (c) | non-list second argument | covered | strict `X=..foo` |
| 8.5.3 error (d) | variable list head | covered | strict `X=..[F,a]` |
| 8.5.3 error (e) | invalid compound functor/list head | covered | strict `X=..[3,a]` and singleton compound-head case |
| 8.5.3 error (f) | empty construction list | covered | strict `X=..[]` |
| 8.5.3 finite-arity representation branch | constructed list exceeds finite `max_arity` | not applicable | selected `max_arity=unbounded` |
| 8.5.4 `copy_term/2` | copy with fresh variables | covered | strict success assertion, `copy_term_fresh_variables`, `logtalk_copy_term_semantics` |
| Cor.2 8.5.5 `term_variables/2` | output witness-variable list | covered | strict `term_variables(A+B+B,[A,B])`, Logtalk-derived cases |
| Cor.2 8.5.5 `term_variables/2` | supplied partial/list result | covered | Corrigendum cases |
| Cor.2 8.5.5 error (a) | second argument neither partial list nor list -> list type error | covered | strict `term_variables(t,[X|foo])` |

## 8.6 — arithmetic evaluation

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.6.1 `is/2` | evaluate the second argument and unify/check the result | covered | strict `X is 1+2, X=3`, arithmetic corpus |
| 8.6.1 failed result unification | a successfully evaluated value need not unify with the first argument | covered | strict `4 is 1+2` fails |
| 8.6.1 error (a) | variable expression -> instantiation error | covered | strict `X is Y` |
| 8.6.1 delegated expression errors | evaluation may report any applicable 7.9.2 error | covered | strict `X is foo` plus Clause 9 arithmetic/error suites |

## 8.7 — arithmetic comparison

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.7.1 `(=:=)/2` | evaluate two expressions and test arithmetic equality | covered | strict `1 =:= 1`, arithmetic comparison corpus |
| 8.7.1 `(=\=)/2` | evaluate two expressions and test arithmetic inequality | covered | strict `1 =\= 2` |
| 8.7.1 `(<)/2` | arithmetic less-than | covered | strict `1 < 2` |
| 8.7.1 `(=<)/2` | arithmetic less-than-or-equal | covered | strict `1 =< 1` |
| 8.7.1 `(>)/2` | arithmetic greater-than | covered | strict `2 > 1` |
| 8.7.1 `(>=)/2` | arithmetic greater-than-or-equal | covered | strict `2 >= 2` |
| 8.7.1 error (a) | first expression variable -> instantiation error | covered | strict variable-first assertions across the comparison family |
| 8.7.1 error (b) | second expression variable -> instantiation error | covered | strict variable-second assertions across the comparison family |
| 8.7.1 delegated expression errors | either expression may report an applicable 7.9.2 error | covered | strict `foo =:= 1` plus Clause 9 error suites |
| 8.7 mixed integer/float operation | selected Part 1 I-to-F comparison operations, including conversion overflow | covered | dedicated strict mixed-comparison tests |

## 8.8 — clause inspection

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.8.1 `clause/2` | enumerate clauses of a public user-defined procedure | covered | dynamic-clause tests and grouped-solutions/clause corpus; `iso/clause_static_and_dynamic_access` and `error/iso/clause_static_user_procedure` pin the static/private default in all modes |
| 8.8.1 error (a) | variable head -> instantiation error | covered | strict `clause(X,_)` |
| 8.8.1 error (b) | non-callable head -> callable type error | covered | strict `clause(4,_)` |
| 8.8.1 error (c) | private procedure -> access/private-procedure permission error | covered | strict static/private tests |
| 8.8.1 error (d) | fixed non-callable Body -> callable type error | covered | strict dynamic `clause(p(_),4)` coverage |
| 8.8.1 clause-to-term conversion | source variable goals become `call/1` while preserving sharing with the head | covered | strict `foo(X):-X` -> `clause(foo(C),call(C))`; nested `;/2` and `->/2` regressions |
| 8.8.2 `current_predicate/1` | enumerate/query user-defined predicate indicators, including empty declared procedures | covered | strict row review and empty-procedure lifetime tests |
| 8.8.2 error (a) | fixed non-predicate-indicator -> predicate-indicator type error | covered | strict `current_predicate(4)` |

## 8.9 — database modification

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.9.1 `asserta/1` | convert term to clause and insert before existing clauses | covered | dynamic-database corpus and strict body-conversion tests |
| 8.9.1 errors (a-b) | variable/non-callable Head -> instantiation/callable type error | covered | strict `asserta(_)`, `asserta(4)` |
| 8.9.1 error (c) | Body cannot be converted to a goal -> callable type error | covered | strict `asserta((p:-4))` and nested-control conversion tests |
| 8.9.1 error (d) | static procedure -> modify/static-procedure permission error | covered | strict static-procedure tests |
| 8.9.2 `assertz/1` | convert term to clause and insert after existing clauses | covered | dynamic-database corpus and strict body-conversion tests |
| 8.9.2 errors (a-d) | same Head/Body/static families as `asserta/1` | covered | strict `assertz(_)`, `assertz(4)`, `assertz((p:-4))`, static-procedure tests |
| 8.9.3 `retract/1` | retract matching dynamic clauses re-executably using the logical update view | covered | dynamic-database and logical-update-view suites |
| 8.9.3 errors (a-b) | variable/non-callable Head -> instantiation/callable type error | covered | strict `retract(_)`, `retract(4)` |
| Cor.2 8.9.3 error (c) | static procedure -> **modify**/static-procedure permission error | covered | strict `retract(atom(_))` and Corrigendum coverage |
| 8.9.3 clause-term matching | converted source body retains head/body variable identity when matched by `retract/1` | covered | strict `retract((foo(C):-call(C)))` regression |
| 8.9.4 `abolish/1` | remove a dynamic procedure | covered | strict lifetime tests |
| 8.9.4 errors (a-b) | variable indicator or variable Name/Arity component -> instantiation error | covered | strict `abolish(X)`, `abolish(foo/X)` |
| 8.9.4 error (c) | non-predicate-indicator -> predicate-indicator type error | covered | strict `abolish(foo)` |
| 8.9.4 error (d) | non-integer Arity -> integer type error | covered | strict `abolish(foo/a)` |
| 8.9.4 error (e) | non-atom Name -> atom type error | covered | strict `abolish(4/1)` |
| 8.9.4 error (f) | negative Arity -> non-negative domain error | covered | strict `abolish(foo/(-1))` |
| 8.9.4 finite-`max_arity` error (g) | Arity exceeds finite `max_arity` | not applicable | selected `max_arity=unbounded` |
| 8.9.4 error (h) | static procedure -> modify/static-procedure permission error | covered | strict `abolish(atom/1)` |
| Cor.2 8.9.5 `retractall/1` | remove all matching dynamic heads while retaining the procedure | covered | strict empty-procedure lifetime test and Corrigendum cases |
| Cor.2 8.9.5 errors (a-c) | variable/non-callable Head or static procedure | covered | strict `retractall(_)`, `retractall(4)`, static-procedure test |

## 8.10 — all solutions

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.10.1 `findall/3` | collect renamed template instances in solution order; empty result succeeds with `[]` | covered | strict `[1,2]` assertion plus all-solutions corpus |
| 8.10.1 error (a) | variable Goal -> instantiation error | covered | strict `findall(X,Y,L)` |
| 8.10.1 error (b) | non-callable Goal -> callable type error | covered | strict `findall(X,4,L)` |
| 8.10.1 error (c) | Instances neither partial list nor list -> list type error | covered | strict `findall(X,true,foo)` |
| 8.10.2 `bagof/3` | non-empty grouped solution lists, re-executable over free-variable witnesses | covered | grouped-solutions corpus and strict `[1,2]` assertion |
| 8.10.2 empty solution set | goal fails rather than returning `[]` | covered | strict `bagof(X,fail,L)` |
| 8.10.2 errors (a-b) | variable/non-callable iterated-goal term -> instantiation/callable type error | covered | strict `bagof(X,Y,L)`, `bagof(X,4,L)` |
| 8.10.2 error (c) | Instances neither partial list nor list -> list type error | covered | strict `bagof(X,true,foo)` |
| 8.10.3 `setof/3` | grouped solutions sorted with duplicates removed | covered | strict duplicate/sort assertion plus grouped-solutions corpus |
| 8.10.3 empty solution set | goal fails rather than returning `[]` | covered | strict `setof(X,fail,L)` |
| 8.10.3 errors (a-b) | variable/non-callable iterated-goal term -> instantiation/callable type error | covered | strict `setof(X,Y,L)`, `setof(X,4,L)` |
| 8.10.3 error (c) | Instances neither partial list nor list -> list type error | covered | strict `setof(X,true,foo)` |
| 8.10.2-3 witness-group order where the standard leaves a choice | implementation dependent | covered | existing grouping tests document EyeProlog's stable selection without turning it into a cross-processor requirement |


## 8.11 — stream selection and control

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.11.1 `current_input/1` | unify/query the current input stream-term | covered | strict current-input success assertion |
| 8.11.1 error | fixed argument is neither variable nor stream-term -> stream domain error | covered | strict `current_input(foo)` |
| 8.11.2 `current_output/1` | unify/query the current output stream-term | covered | strict current-output success assertion |
| 8.11.2 error | fixed argument is neither variable nor stream-term -> stream domain error | covered | strict `current_output(foo)` |
| 8.11.3 `set_input/1` | select an open input stream by stream-term or alias | covered | stream-selection corpus |
| 8.11.3 errors | variable; invalid stream-or-alias; missing stream; output stream | covered | dedicated strict assertions for all four conditions |
| 8.11.4 `set_output/1` | select an open output stream by stream-term or alias | covered | stream-selection corpus |
| 8.11.4 errors | variable; invalid stream-or-alias; missing stream; input stream | covered | dedicated strict assertions for all four conditions |
| 8.11.5 `open/4`, `open/3` | open a source/sink with standardized mode/options and return a fresh stream | covered | stream corpus plus strict successful/error probes |
| 8.11.5 errors: instantiation | variable source/mode or variable option element | covered | strict `open/4` assertions |
| 8.11.5 errors: argument shapes | non-atom mode; non-list options; non-variable stream output (Cor.2 uninstantiation) | covered | strict `open/4` assertions |
| 8.11.5 errors: domains | invalid source/sink, I/O mode, or stream option | covered | strict `open/4` assertions |
| 8.11.5 source/sink errors | missing read source or source/sink that cannot be opened | covered | strict host-I/O probes for existence/permission conditions |
| 8.11.5 alias collision | `alias(A)` already names an open stream -> open permission error with complete `alias(A)` culprit | covered | focused alias-collision regression |
| 8.11.5 `reposition(true)` impossible | permission error when the requested stream cannot be repositioned | covered | stream option corpus and implementation-defined stream capability checks |
| 8.11.6 `close/2`, `close/1` | close an open non-standard stream and maintain current-stream fallbacks | covered | stream lifecycle corpus |
| 8.11.6 errors | variable stream/option element; non-list options; invalid stream-or-alias; invalid close option; missing stream | covered | strict close assertions |
| 8.11.6 `force(true)` | presence of `force(true)` suppresses resource/system close failure regardless of contradictory later `force(false)` | covered | dedicated two-order strict regression |
| 8.11.7 `flush_output/1`, `flush_output/0` | flush an output stream/current output | covered | strict success assertion and stream corpus |
| 8.11.7 errors | variable; invalid stream-or-alias; missing stream; input stream | covered | dedicated strict assertions |
| 8.11.8 `stream_property/2` | enumerate properties of currently open streams; order is implementation dependent | covered | stream-property corpus and strict checks |
| 8.11.8 stream-term error | fixed non-stream-term -> stream domain error | covered | strict `stream_property(foo,_)` |
| 8.11.8 property error | fixed non-stream-property -> stream-property domain error | covered | strict invalid-property assertion |
| 8.11.8 closed valid stream-term | no pair exists for a stream that is no longer open -> fail | covered | dedicated closed-stream regression |
| 8.11.8 `at_end_of_stream/0-1` | test current/named stream end or past-end state | covered | strict success and EOF corpus |
| 8.11.8 `at_end_of_stream/1` errors | variable; invalid stream-or-alias; missing stream | covered | dedicated strict assertions |
| 8.11.9 `set_stream_position/2` | set a repositionable open stream to a valid stream position | covered | dedicated positioned-stream success assertion |
| 8.11.9 errors | variable stream/position; invalid stream-or-alias/position; missing stream; non-repositionable stream | covered | dedicated strict assertions |

## 8.12 — character input/output

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.12.1 `get_char/1-2` | input next text character or EOF indicator | covered | stream/character corpus and strict probes |
| 8.12.1 `get_code/1-2` | input next text character code or `-1` at EOF | covered | stream/code corpus and strict probes |
| 8.12.1 argument errors | variable stream; invalid fixed in-character; non-integer fixed code | covered | dedicated strict assertions |
| 8.12.1 stream errors | invalid stream-or-alias; missing stream; output stream; binary stream; past-end with `eof_action(error)` | covered | dedicated strict and constructed-stream assertions |
| 8.12.1 input entity/code representation | non-character input entity or fixed integer not an in-character code | covered | strict entity/code representation regressions; bad-code check is deferred until earlier stream/entity conditions are resolved |
| 8.12.2 `peek_char/1-2`, `peek_code/1-2` | inspect next character/code without changing stream position | covered | strict probes and stream corpus |
| 8.12.2 errors | corresponding 8.12.1 argument, stream, EOF, entity and code-representation conditions | covered | dedicated strict assertions including overlap regression |
| 8.12.3 `put_char/1-2` | output one text character | covered | output corpus |
| 8.12.3 `put_code/1-2` | output character selected by character code | covered | output corpus |
| 8.12.3 `nl/0-1` | output implementation-defined new-line character | covered | output corpus |
| 8.12.3 argument errors | variable character/code or wrong character/integer type | covered | dedicated strict assertions |
| 8.12.3 stream errors | variable/invalid/missing stream; input stream; binary stream | covered | dedicated strict and constructed-stream assertions |
| 8.12.3 character-code representation | integer outside processor character-code set | covered | strict `put_code/1` boundary assertion |

## 8.13 — byte input/output

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.13.1 `get_byte/1-2` | input next byte or `-1` at EOF | covered | strict binary-stream success and byte corpus |
| 8.13.1 errors | variable stream; invalid fixed in-byte; invalid/missing/output stream; text stream; EOF-action conditions | covered | strict assertions and EOF stream corpus |
| 8.13.2 `peek_byte/1-2` | inspect next byte without changing position | covered | strict binary-stream success and byte corpus |
| 8.13.2 errors | corresponding fixed-byte, stream, text-stream, and EOF conditions | covered | strict assertions / shared byte-I/O implementation tests |
| 8.13.3 `put_byte/1-2` | output one byte to a binary stream | covered | strict binary-output success and byte corpus |
| 8.13.3 errors | variable byte/stream; non-byte value; invalid/missing/input stream; text stream | covered | dedicated strict assertions |

## 8.14 — term input/output, operators, and character conversion

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.14.1 `read_term/3`, `read_term/2`, `read/1-2` | read a term using the standardized read-option surface | covered | term-I/O corpus, Corrigendum 3 cases, strict success/error suite |
| 8.14.1 option/argument errors | stream/option instantiation, non-list options, invalid read option | covered | strict 8.14.1 individual-condition assertions |
| 8.14.1 stream/input errors | invalid/missing/output/binary stream, past-end state, invalid input character, syntax error | covered | strict and constructed-stream assertions; post-N289 STC #76 is pinned by invalid-character read regressions |
| 8.14.1 conditional finite-number/arity representation branches | limits tied to finite selected processor bounds | not applicable where bound is unbounded | EyeProlog selects unbounded integers/`max_arity`; the implementation-defined finite binary64 input limits are pinned separately, including post-N289 STC #73 `max_float` / `min_float` coverage |
| 8.14.1 Corrigendum options | `variables/1`, `variable_names/1`, `singletons/1` list traversal/unification behavior | covered | Corrigendum 3 metadata tests and STC #48 regression |
| 8.14.2 `write_term/3`, `write_term/2`, `write/1-2`, `writeq/1-2` | write terms under standardized write options | covered | term-I/O/write-back corpus and strict writer suite |
| 8.14.2 option/argument errors | stream/option instantiation, non-list options, invalid write option | covered | strict 8.14.2 assertions |
| 8.14.2 stream/output errors | invalid/missing/input/binary stream and character representation conditions | covered | strict and constructed-stream assertions |
| 8.14.2 contradictory write options | rightmost option applies | covered | writer option corpus |
| 8.14.3 `op/3` | add/remove operators subject to Part 1 restrictions | covered | operator corpus and preparation-time ordering tests |
| 8.14.3 errors | priority/specifier/name instantiation/type/domain plus protected-operator permission conditions | covered | strict `op/3` individual-condition suite |
| 8.14.4 `current_op/3` | enumerate/query current operator definitions | covered | operator corpus and strict success assertion |
| 8.14.4 errors | invalid priority/specifier/operator filters | covered | strict `current_op/3` individual-condition suite |
| 8.14.5 `char_conversion/2` | update character-conversion mapping | covered | preparation/runtime conversion tests and strict success assertion |
| 8.14.5 errors | input/output instantiation and processor-character representation conditions | covered | dedicated strict assertions |
| 8.14.6 `current_char_conversion/2` | enumerate/query current conversion mapping | covered | strict success assertion and conversion corpus |
| 8.14.6 errors | fixed input/output is not a character | covered | dedicated strict assertions |

## 8.15 — logic and control

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.15.1 `(\+)/1` | callable goal; semidet | covered | negation corpus |
| 8.15.1 error (a) | variable goal -> instantiation error | covered | strict `\+(X)` |
| 8.15.1 error (b) | non-callable goal -> callable type error | covered | strict `\+(3)` |
| 8.15.2 `once/1` | callable goal; only first solution survives | covered | direct strict solver assertion, `once_commits_first`, `logtalk_once` |
| 8.15.2 error (a) | variable goal -> instantiation error | covered | strict `once(X)` |
| 8.15.2 error (b) | non-callable goal -> callable type error | covered | strict `once(3)` |
| 8.15.3 `repeat/0` | repeatedly succeeds; no prescribed errors | covered | `logtalk_repeat` |
| Cor.2 8.15.4 `call/2..8` | closure expansion through the standardized maximum arity | covered | direct strict closure assertion and `corrigenda_call_closure` |
| Cor.2 8.15.4 error (a) | variable closure -> instantiation error | covered | strict `call(X,a)` |
| Cor.2 8.15.4 error (b) | non-callable closure -> callable type error | covered | strict `call(3,a)` |
| Cor.2 8.15.4 finite-`max_arity` branch | resulting goal exceeds finite `max_arity` | not applicable | selected `max_arity=unbounded`; branch remains implementation-tested conditionally |
| Cor.2 8.15.4 implementation-dependent `call/N`, N>=9 | EyeProlog supplies no additional standardized closure arities | covered | strict `call(foo,a,b,c,d,e,f,g,h)` reaches procedure-existence handling rather than an extra call/N built-in |
| Cor.2 8.15.4 resulting-goal conversion error | expanded goal cannot be converted to a callable goal | covered | strict callability/error tests |
| Cor.2 8.15.5 `false/0` | always fails; no prescribed errors | covered | strict assertion and `false_builtin` |

## 8.16 — atomic term processing

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.16.1 `atom_length/2` | atom -> length / check supplied length | covered | `logtalk_atom_length`, strict row review |
| 8.16.1 error: atom variable | required atom unavailable -> instantiation error | covered | strict `atom_length(X,4)` |
| 8.16.1 error: atom type | first argument non-atom -> atom type error | covered | strict `atom_length(1.2,4)` |
| 8.16.1 error: length type | non-integer length -> integer type error | covered | strict `atom_length(atom,'4')` |
| 8.16.1 error: length domain | negative length -> non-negative domain error | covered | strict `atom_length(atom,-1)` |
| 8.16.2 `atom_concat/3` | concatenate known pieces or enumerate splits of known whole | covered | direct strict enumeration assertion and `logtalk_atom_concat` |
| 8.16.2 errors: insufficient first/whole or second/whole instantiation | instantiation error | covered | strict `atom_concat(X,small,Y)` and `atom_concat(small,X,Y)` |
| 8.16.2 errors: atom types | non-atom in each fixed position -> atom type error | covered | three strict type assertions |
| 8.16.3 `sub_atom/5` | enumerate/check source slices | covered | direct strict six-slice assertion and `logtalk_sub_atom` |
| 8.16.3 error: source variable | instantiation error | covered | strict `sub_atom(X,0,1,0,a)` |
| 8.16.3 errors: atom types | source/result non-atom -> atom type error | covered | strict source/result assertions |
| 8.16.3 errors: integer types | fixed Before/Length/After non-integer -> integer type error | covered | three strict assertions |
| 8.16.3 errors: non-negative domains | fixed Before/Length/After negative -> domain error | covered | three strict assertions |
| 8.16.4 `atom_chars/2` | atom <-> list of characters | covered | forward/reverse and Logtalk-derived cases |
| Cor.2 `atom_chars/2`: both insufficiently instantiated | instantiation error | covered | strict `atom_chars(X,Y)` |
| Cor.2 `atom_chars/2`: atom type | atom side non-atom | covered | strict `atom_chars(1,[])` |
| Cor.2 `atom_chars/2`: improper list | list type error on complete list culprit | covered | strict `atom_chars(X,[a|foo])` and focused culprit regressions |
| Cor.2 `atom_chars/2`: variable list-prefix element | instantiation error | covered | strict `atom_chars(X,[Y,a])` |
| Cor.2 `atom_chars/2`: non-character element | character type error | covered | strict `atom_chars(X,[a,1])` |
| 8.16.5 `atom_codes/2` | atom <-> list of character codes | covered | forward/reverse and Logtalk-derived cases |
| Cor.2 `atom_codes/2`: both insufficiently instantiated | instantiation error | covered | strict `atom_codes(X,Y)` |
| Cor.2 `atom_codes/2`: atom type | atom side non-atom | covered | strict `atom_codes(1,[])` |
| Cor.2 `atom_codes/2`: improper list | list type error on complete list culprit | covered | strict `atom_codes(X,[97|foo])` |
| Cor.2 `atom_codes/2`: variable prefix element | instantiation error | covered | strict `atom_codes(X,[Y,97])` |
| Cor.2 `atom_codes/2`: code type | non-integer code -> integer type error | covered | strict `atom_codes(X,[97,foo])` |
| Cor.2 `atom_codes/2`: code representation | integer outside processor character-code set -> representation error | covered | strict `atom_codes(X,[97,-1])` |
| 8.16.6 `char_code/2` | character <-> character code | covered | forward/reverse cases |
| 8.16.6 under-instantiation | both sides variable -> instantiation error | covered | strict `char_code(X,Y)` |
| 8.16.6 character type | non-character first argument takes precedence | covered | strict `char_code(ab,foo)` |
| 8.16.6 code type | non-integer code -> integer type error | covered | strict `char_code(a,foo)` |
| 8.16.6 code representation | integer outside processor character-code set -> representation error | covered | strict `char_code(a,-1)` |
| 8.16.7 `number_chars/2` | number <-> character-list number syntax | covered | number conversion corpus |
| Cor.2 `number_chars/2`: both insufficiently instantiated | instantiation error | covered | strict `number_chars(X,Y)` |
| Cor.2 `number_chars/2`: number type | fixed non-number -> number type error | covered | strict `number_chars(foo,[])` |
| Cor.2 `number_chars/2`: improper list | list type error | covered | strict `number_chars(X,[a|foo])` |
| Cor.2 `number_chars/2`: variable prefix element | instantiation error | covered | strict `number_chars(X,[Y,a])` |
| Cor.2 `number_chars/2`: non-character element | character type error | covered | strict `number_chars(X,[a,1])` |
| `number_chars/2`: invalid number syntax | syntax error | covered | strict `number_chars(X,[a])` and parenthesized-number rejection |
| 8.16.8 `number_codes/2` | number <-> code-list number syntax | covered | number conversion corpus |
| Cor.2 `number_codes/2`: both insufficiently instantiated | instantiation error | covered | strict `number_codes(X,Y)` |
| Cor.2 `number_codes/2`: number type | fixed non-number -> number type error | covered | strict `number_codes(foo,[])` |
| Cor.2 `number_codes/2`: improper list | list type error | covered | strict `number_codes(X,[49|foo])` |
| Cor.2 `number_codes/2`: variable prefix element | instantiation error | covered | strict `number_codes(X,[Y,49])` |
| Cor.2 `number_codes/2`: code type | non-integer code -> integer type error | covered | strict `number_codes(X,[49,foo])` |
| Cor.2 `number_codes/2`: code representation | integer outside processor character-code set -> representation error | covered | strict `number_codes(X,[49,-1])` |
| `number_codes/2`: invalid number syntax | syntax error | covered | strict `number_codes(X,[97])` |

## 8.17 — flags and hooks

The complete Part 1 flag family had already been closed before this tranche;
these rows make the corresponding built-in modes/errors explicit here so the
built-in matrix does not have a gap at 8.17.

| Clause / predicate | Prescribed row | Status | Executable evidence |
| --- | --- | --- | --- |
| 8.17.1 `set_prolog_flag/2` | set a supported, changeable flag value | covered | strict flag review |
| 8.17.1 errors | variable/name type/domain, value type/domain, and non-changeable-flag permission distinctions | covered | `covers the Part 1 flag defaults, value domains, and changeability` plus file-based flag errors |
| 8.17.2 `current_prolog_flag/2` | enumerate/query current standard flags | covered | strict complete flag review |
| 8.17.2 flag-name type error | fixed non-atom name -> atom type error | covered | strict `current_prolog_flag(1,_)` |
| 8.17.2 unknown-flag domain error | fixed unsupported flag name -> Prolog-flag domain error | covered | strict `current_prolog_flag(no_such_iso_flag,_)` |
| 8.17.3 `halt/0` | terminate with implementation-defined successful host status | covered | `halt` conformance case / host runner tests |
| 8.17.4 `halt/1` | integer host status | covered | halt conformance/runner tests |
| 8.17.4 variable status | instantiation error | covered | strict `halt(X)` |
| 8.17.4 non-integer status | integer type error | covered | strict `halt(a)` |

## Closure note

The built-in **8.2-8.17 row review is complete** at the level tracked by this
file: prescribed modes, success/failure behavior, individual error conditions,
and conditional/not-applicable processor branches all have explicit outcomes.
“Row review” means condition-by-condition accounting; it does not promise one
Markdown table row per condition when a grouped row enumerates them all.
ISO 7.12 simultaneous-error selection remains an implementation-dependent
processor choice unless more specific normative text constrains it.

The surrounding Clause 5-7 processor requirements are closed in
`ISO-PROCESSOR-REQUIREMENTS.md` and `ISO-COMPLIANCE.md`; this matrix remains the
detailed evidence for the 8.2-8.17 built-in layer.
