text_body(call(true)).
nested_body(((call(a) ; call(b)), (call(c) -> true ; true))).
assert_agrees_with_text(agree).
cut_is_local([taken, taken]).
