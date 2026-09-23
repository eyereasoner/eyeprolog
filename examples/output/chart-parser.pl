chart_parser_answer(parsed, command).
chart_parser_answer(parsed, ambiguous_pp).
chart_parser_answer(parse_count, count(command, 1)).
chart_parser_answer(parse_count, count(ambiguous_pp, 1)).
chart_parser_answer(noun_phrase_count, count(command, 2)).
chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)).
