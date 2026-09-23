:- include('test/conformance/cases/iso/include_payload.inc').
:- ensure_loaded('test/conformance/cases/iso/include_payload.inc').
:- ensure_loaded('test/conformance/cases/iso/include_payload.inc').

%% ?- included_answer(X).

included_answer(X) :-
    included(X).
