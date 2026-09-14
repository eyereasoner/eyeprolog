answer(25, [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)]).
why(
  answer(25, [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)]),
  proof(
    goal(answer(25, [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)])),
    by(rule("knights-tour-warnsdorff.pl", clause(7))),
    bindings([binding("SquareCount", 25), binding("Tour", [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)])]),
    uses([
      proof(
        goal(knights_tour(p(1, 1), [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)])),
        by(rule("knights-tour-warnsdorff.pl", clause(6))),
        bindings([binding("Start", p(1, 1)), binding("Tour", [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)]), binding("N", 5), binding("SquareCount", 25), binding("ReverseTour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])]),
        uses([
          proof(
            goal(board_size(5)),
            by(fact("knights-tour-warnsdorff.pl", clause(1)))
          ),
          proof(
            goal(is(25, *(5, 5))),
            by(builtin(is, 2))
          ),
          proof(
            goal(tour_(p(1, 1), [p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
            by(rule("knights-tour-warnsdorff.pl", clause(5))),
            bindings([binding("Current", p(1, 1)), binding("Visited", [p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(5, p(2, 3)), '-'(5, p(3, 2))]), binding("__anon1", 5), binding("Best", p(2, 3)), binding("__anon2", ['-'(5, p(3, 2))])]),
            uses([
              proof(
                goal(findall('-'(Degree, Next), (knight_move(p(1, 1), Next), '\\+'(member(Next, [p(1, 1)])), degree(Next, [p(1, 1)], Degree)), ['-'(5, p(2, 3)), '-'(5, p(3, 2))])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(\=(['-'(5, p(2, 3)), '-'(5, p(3, 2))], [])),
                by(builtin(\=, 2))
              ),
              proof(
                goal(keysort(['-'(5, p(2, 3)), '-'(5, p(3, 2))], ['-'(5, p(2, 3)), '-'(5, p(3, 2))])),
                by(builtin(keysort, 2))
              ),
              proof(
                goal(tour_(p(2, 3), [p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                bindings([binding("Current", p(2, 3)), binding("Visited", [p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(1, p(1, 5)), '-'(3, p(3, 1)), '-'(3, p(4, 2))]), binding("__anon1", 1), binding("Best", p(1, 5)), binding("__anon2", ['-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(3, p(3, 1)), '-'(3, p(4, 2))])]),
                uses([
                  proof(
                    goal(findall('-'(Degree, Next), (knight_move(p(2, 3), Next), '\\+'(member(Next, [p(2, 3), p(1, 1)])), degree(Next, [p(2, 3), p(1, 1)], Degree)), ['-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(1, p(1, 5)), '-'(3, p(3, 1)), '-'(3, p(4, 2))])),
                    by(builtin(findall, 3))
                  ),
                  proof(
                    goal(\=(['-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(1, p(1, 5)), '-'(3, p(3, 1)), '-'(3, p(4, 2))], [])),
                    by(builtin(\=, 2))
                  ),
                  proof(
                    goal(keysort(['-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(1, p(1, 5)), '-'(3, p(3, 1)), '-'(3, p(4, 2))], ['-'(1, p(1, 5)), '-'(3, p(3, 5)), '-'(3, p(4, 4)), '-'(3, p(3, 1)), '-'(3, p(4, 2))])),
                    by(builtin(keysort, 2))
                  ),
                  proof(
                    goal(tour_(p(1, 5), [p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                    bindings([binding("Current", p(1, 5)), binding("Visited", [p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(5, p(3, 4))]), binding("__anon1", 5), binding("Best", p(3, 4)), binding("__anon2", [])]),
                    uses([
                      proof(
                        goal(findall('-'(Degree, Next), (knight_move(p(1, 5), Next), '\\+'(member(Next, [p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(5, p(3, 4))])),
                        by(builtin(findall, 3))
                      ),
                      proof(
                        goal(\=(['-'(5, p(3, 4))], [])),
                        by(builtin(\=, 2))
                      ),
                      proof(
                        goal(keysort(['-'(5, p(3, 4))], ['-'(5, p(3, 4))])),
                        by(builtin(keysort, 2))
                      ),
                      proof(
                        goal(tour_(p(3, 4), [p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                        bindings([binding("Current", p(3, 4)), binding("Visited", [p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(5, 5)), '-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))]), binding("__anon1", 1), binding("Best", p(5, 5)), binding("__anon2", ['-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))])]),
                        uses([
                          proof(
                            goal(findall('-'(Degree, Next), (knight_move(p(3, 4), Next), '\\+'(member(Next, [p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(5, 5)), '-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))])),
                            by(builtin(findall, 3))
                          ),
                          proof(
                            goal(\=(['-'(1, p(5, 5)), '-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))], [])),
                            by(builtin(\=, 2))
                          ),
                          proof(
                            goal(keysort(['-'(1, p(5, 5)), '-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))], ['-'(1, p(5, 5)), '-'(2, p(4, 2)), '-'(3, p(5, 3)), '-'(3, p(2, 2)), '-'(3, p(1, 3))])),
                            by(builtin(keysort, 2))
                          ),
                          proof(
                            goal(tour_(p(5, 5), [p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                            by(rule("knights-tour-warnsdorff.pl", clause(5))),
                            bindings([binding("Current", p(5, 5)), binding("Visited", [p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(5, p(4, 3))]), binding("__anon1", 5), binding("Best", p(4, 3)), binding("__anon2", [])]),
                            uses([
                              proof(
                                goal(findall('-'(Degree, Next), (knight_move(p(5, 5), Next), '\\+'(member(Next, [p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(5, p(4, 3))])),
                                by(builtin(findall, 3))
                              ),
                              proof(
                                goal(\=(['-'(5, p(4, 3))], [])),
                                by(builtin(\=, 2))
                              ),
                              proof(
                                goal(keysort(['-'(5, p(4, 3))], ['-'(5, p(4, 3))])),
                                by(builtin(keysort, 2))
                              ),
                              proof(
                                goal(tour_(p(4, 3), [p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                bindings([binding("Current", p(4, 3)), binding("Visited", [p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(3, 5)), '-'(3, p(2, 4)), '-'(1, p(5, 1)), '-'(2, p(3, 1)), '-'(2, p(2, 2))]), binding("__anon1", 1), binding("Best", p(5, 1)), binding("__anon2", ['-'(2, p(3, 5)), '-'(2, p(3, 1)), '-'(2, p(2, 2)), '-'(3, p(2, 4))])]),
                                uses([
                                  proof(
                                    goal(findall('-'(Degree, Next), (knight_move(p(4, 3), Next), '\\+'(member(Next, [p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(3, 5)), '-'(3, p(2, 4)), '-'(1, p(5, 1)), '-'(2, p(3, 1)), '-'(2, p(2, 2))])),
                                    by(builtin(findall, 3))
                                  ),
                                  proof(
                                    goal(\=(['-'(2, p(3, 5)), '-'(3, p(2, 4)), '-'(1, p(5, 1)), '-'(2, p(3, 1)), '-'(2, p(2, 2))], [])),
                                    by(builtin(\=, 2))
                                  ),
                                  proof(
                                    goal(keysort(['-'(2, p(3, 5)), '-'(3, p(2, 4)), '-'(1, p(5, 1)), '-'(2, p(3, 1)), '-'(2, p(2, 2))], ['-'(1, p(5, 1)), '-'(2, p(3, 5)), '-'(2, p(3, 1)), '-'(2, p(2, 2)), '-'(3, p(2, 4))])),
                                    by(builtin(keysort, 2))
                                  ),
                                  proof(
                                    goal(tour_(p(5, 1), [p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                    bindings([binding("Current", p(5, 1)), binding("Visited", [p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(4, p(3, 2))]), binding("__anon1", 4), binding("Best", p(3, 2)), binding("__anon2", [])]),
                                    uses([
                                      proof(
                                        goal(findall('-'(Degree, Next), (knight_move(p(5, 1), Next), '\\+'(member(Next, [p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(4, p(3, 2))])),
                                        by(builtin(findall, 3))
                                      ),
                                      proof(
                                        goal(\=(['-'(4, p(3, 2))], [])),
                                        by(builtin(\=, 2))
                                      ),
                                      proof(
                                        goal(keysort(['-'(4, p(3, 2))], ['-'(4, p(3, 2))])),
                                        by(builtin(keysort, 2))
                                      ),
                                      proof(
                                        goal(tour_(p(3, 2), [p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                        bindings([binding("Current", p(3, 2)), binding("Visited", [p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(4, 4)), '-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))]), binding("__anon1", 2), binding("Best", p(4, 4)), binding("__anon2", ['-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))])]),
                                        uses([
                                          proof(
                                            goal(findall('-'(Degree, Next), (knight_move(p(3, 2), Next), '\\+'(member(Next, [p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(4, 4)), '-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))])),
                                            by(builtin(findall, 3))
                                          ),
                                          proof(
                                            goal(\=(['-'(2, p(4, 4)), '-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))], [])),
                                            by(builtin(\=, 2))
                                          ),
                                          proof(
                                            goal(keysort(['-'(2, p(4, 4)), '-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))], ['-'(2, p(4, 4)), '-'(2, p(5, 3)), '-'(2, p(2, 4)), '-'(2, p(1, 3))])),
                                            by(builtin(keysort, 2))
                                          ),
                                          proof(
                                            goal(tour_(p(4, 4), [p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                            by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                            bindings([binding("Current", p(4, 4)), binding("Visited", [p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(2, 5)), '-'(2, p(5, 2))]), binding("__anon1", 2), binding("Best", p(2, 5)), binding("__anon2", ['-'(2, p(5, 2))])]),
                                            uses([
                                              proof(
                                                goal(findall('-'(Degree, Next), (knight_move(p(4, 4), Next), '\\+'(member(Next, [p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(2, 5)), '-'(2, p(5, 2))])),
                                                by(builtin(findall, 3))
                                              ),
                                              proof(
                                                goal(\=(['-'(2, p(2, 5)), '-'(2, p(5, 2))], [])),
                                                by(builtin(\=, 2))
                                              ),
                                              proof(
                                                goal(keysort(['-'(2, p(2, 5)), '-'(2, p(5, 2))], ['-'(2, p(2, 5)), '-'(2, p(5, 2))])),
                                                by(builtin(keysort, 2))
                                              ),
                                              proof(
                                                goal(tour_(p(2, 5), [p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                bindings([binding("Current", p(2, 5)), binding("Visited", [p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(7, p(3, 3)), '-'(1, p(1, 3))]), binding("__anon1", 1), binding("Best", p(1, 3)), binding("__anon2", ['-'(7, p(3, 3))])]),
                                                uses([
                                                  proof(
                                                    goal(findall('-'(Degree, Next), (knight_move(p(2, 5), Next), '\\+'(member(Next, [p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(7, p(3, 3)), '-'(1, p(1, 3))])),
                                                    by(builtin(findall, 3))
                                                  ),
                                                  proof(
                                                    goal(\=(['-'(7, p(3, 3)), '-'(1, p(1, 3))], [])),
                                                    by(builtin(\=, 2))
                                                  ),
                                                  proof(
                                                    goal(keysort(['-'(7, p(3, 3)), '-'(1, p(1, 3))], ['-'(1, p(1, 3)), '-'(7, p(3, 3))])),
                                                    by(builtin(keysort, 2))
                                                  ),
                                                  proof(
                                                    goal(tour_(p(1, 3), [p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                    bindings([binding("Current", p(1, 3)), binding("Visited", [p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(2, 1))]), binding("__anon1", 2), binding("Best", p(2, 1)), binding("__anon2", [])]),
                                                    uses([
                                                      proof(
                                                        goal(findall('-'(Degree, Next), (knight_move(p(1, 3), Next), '\\+'(member(Next, [p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(2, 1))])),
                                                        by(builtin(findall, 3))
                                                      ),
                                                      proof(
                                                        goal(\=(['-'(2, p(2, 1))], [])),
                                                        by(builtin(\=, 2))
                                                      ),
                                                      proof(
                                                        goal(keysort(['-'(2, p(2, 1))], ['-'(2, p(2, 1))])),
                                                        by(builtin(keysort, 2))
                                                      ),
                                                      proof(
                                                        goal(tour_(p(2, 1), [p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                        bindings([binding("Current", p(2, 1)), binding("Visited", [p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(6, p(3, 3)), '-'(1, p(4, 2))]), binding("__anon1", 1), binding("Best", p(4, 2)), binding("__anon2", ['-'(6, p(3, 3))])]),
                                                        uses([
                                                          proof(
                                                            goal(findall('-'(Degree, Next), (knight_move(p(2, 1), Next), '\\+'(member(Next, [p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(6, p(3, 3)), '-'(1, p(4, 2))])),
                                                            by(builtin(findall, 3))
                                                          ),
                                                          proof(
                                                            goal(\=(['-'(6, p(3, 3)), '-'(1, p(4, 2))], [])),
                                                            by(builtin(\=, 2))
                                                          ),
                                                          proof(
                                                            goal(keysort(['-'(6, p(3, 3)), '-'(1, p(4, 2))], ['-'(1, p(4, 2)), '-'(6, p(3, 3))])),
                                                            by(builtin(keysort, 2))
                                                          ),
                                                          proof(
                                                            goal(tour_(p(4, 2), [p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                            by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                            bindings([binding("Current", p(4, 2)), binding("Visited", [p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(5, 4))]), binding("__anon1", 2), binding("Best", p(5, 4)), binding("__anon2", [])]),
                                                            uses([
                                                              proof(
                                                                goal(findall('-'(Degree, Next), (knight_move(p(4, 2), Next), '\\+'(member(Next, [p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(5, 4))])),
                                                                by(builtin(findall, 3))
                                                              ),
                                                              proof(
                                                                goal(\=(['-'(2, p(5, 4))], [])),
                                                                by(builtin(\=, 2))
                                                              ),
                                                              proof(
                                                                goal(keysort(['-'(2, p(5, 4))], ['-'(2, p(5, 4))])),
                                                                by(builtin(keysort, 2))
                                                              ),
                                                              proof(
                                                                goal(tour_(p(5, 4), [p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                bindings([binding("Current", p(5, 4)), binding("Visited", [p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(3, 5)), '-'(5, p(3, 3))]), binding("__anon1", 1), binding("Best", p(3, 5)), binding("__anon2", ['-'(5, p(3, 3))])]),
                                                                uses([
                                                                  proof(
                                                                    goal(findall('-'(Degree, Next), (knight_move(p(5, 4), Next), '\\+'(member(Next, [p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(3, 5)), '-'(5, p(3, 3))])),
                                                                    by(builtin(findall, 3))
                                                                  ),
                                                                  proof(
                                                                    goal(\=(['-'(1, p(3, 5)), '-'(5, p(3, 3))], [])),
                                                                    by(builtin(\=, 2))
                                                                  ),
                                                                  proof(
                                                                    goal(keysort(['-'(1, p(3, 5)), '-'(5, p(3, 3))], ['-'(1, p(3, 5)), '-'(5, p(3, 3))])),
                                                                    by(builtin(keysort, 2))
                                                                  ),
                                                                  proof(
                                                                    goal(tour_(p(3, 5), [p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                    bindings([binding("Current", p(3, 5)), binding("Visited", [p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(1, 4))]), binding("__anon1", 2), binding("Best", p(1, 4)), binding("__anon2", [])]),
                                                                    uses([
                                                                      proof(
                                                                        goal(findall('-'(Degree, Next), (knight_move(p(3, 5), Next), '\\+'(member(Next, [p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(1, 4))])),
                                                                        by(builtin(findall, 3))
                                                                      ),
                                                                      proof(
                                                                        goal(\=(['-'(2, p(1, 4))], [])),
                                                                        by(builtin(\=, 2))
                                                                      ),
                                                                      proof(
                                                                        goal(keysort(['-'(2, p(1, 4))], ['-'(2, p(1, 4))])),
                                                                        by(builtin(keysort, 2))
                                                                      ),
                                                                      proof(
                                                                        goal(tour_(p(1, 4), [p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                        bindings([binding("Current", p(1, 4)), binding("Visited", [p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(2, 2)), '-'(4, p(3, 3))]), binding("__anon1", 1), binding("Best", p(2, 2)), binding("__anon2", ['-'(4, p(3, 3))])]),
                                                                        uses([
                                                                          proof(
                                                                            goal(findall('-'(Degree, Next), (knight_move(p(1, 4), Next), '\\+'(member(Next, [p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(2, 2)), '-'(4, p(3, 3))])),
                                                                            by(builtin(findall, 3))
                                                                          ),
                                                                          proof(
                                                                            goal(\=(['-'(1, p(2, 2)), '-'(4, p(3, 3))], [])),
                                                                            by(builtin(\=, 2))
                                                                          ),
                                                                          proof(
                                                                            goal(keysort(['-'(1, p(2, 2)), '-'(4, p(3, 3))], ['-'(1, p(2, 2)), '-'(4, p(3, 3))])),
                                                                            by(builtin(keysort, 2))
                                                                          ),
                                                                          proof(
                                                                            goal(tour_(p(2, 2), [p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                            by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                            bindings([binding("Current", p(2, 2)), binding("Visited", [p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(4, 1))]), binding("__anon1", 2), binding("Best", p(4, 1)), binding("__anon2", [])]),
                                                                            uses([
                                                                              proof(
                                                                                goal(findall('-'(Degree, Next), (knight_move(p(2, 2), Next), '\\+'(member(Next, [p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(4, 1))])),
                                                                                by(builtin(findall, 3))
                                                                              ),
                                                                              proof(
                                                                                goal(\=(['-'(2, p(4, 1))], [])),
                                                                                by(builtin(\=, 2))
                                                                              ),
                                                                              proof(
                                                                                goal(keysort(['-'(2, p(4, 1))], ['-'(2, p(4, 1))])),
                                                                                by(builtin(keysort, 2))
                                                                              ),
                                                                              proof(
                                                                                goal(tour_(p(4, 1), [p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                bindings([binding("Current", p(4, 1)), binding("Visited", [p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(5, 3)), '-'(3, p(3, 3))]), binding("__anon1", 1), binding("Best", p(5, 3)), binding("__anon2", ['-'(3, p(3, 3))])]),
                                                                                uses([
                                                                                  proof(
                                                                                    goal(findall('-'(Degree, Next), (knight_move(p(4, 1), Next), '\\+'(member(Next, [p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(5, 3)), '-'(3, p(3, 3))])),
                                                                                    by(builtin(findall, 3))
                                                                                  ),
                                                                                  proof(
                                                                                    goal(\=(['-'(1, p(5, 3)), '-'(3, p(3, 3))], [])),
                                                                                    by(builtin(\=, 2))
                                                                                  ),
                                                                                  proof(
                                                                                    goal(keysort(['-'(1, p(5, 3)), '-'(3, p(3, 3))], ['-'(1, p(5, 3)), '-'(3, p(3, 3))])),
                                                                                    by(builtin(keysort, 2))
                                                                                  ),
                                                                                  proof(
                                                                                    goal(tour_(p(5, 3), [p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                    bindings([binding("Current", p(5, 3)), binding("Visited", [p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(4, 5))]), binding("__anon1", 2), binding("Best", p(4, 5)), binding("__anon2", [])]),
                                                                                    uses([
                                                                                      proof(
                                                                                        goal(findall('-'(Degree, Next), (knight_move(p(5, 3), Next), '\\+'(member(Next, [p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(4, 5))])),
                                                                                        by(builtin(findall, 3))
                                                                                      ),
                                                                                      proof(
                                                                                        goal(\=(['-'(2, p(4, 5))], [])),
                                                                                        by(builtin(\=, 2))
                                                                                      ),
                                                                                      proof(
                                                                                        goal(keysort(['-'(2, p(4, 5))], ['-'(2, p(4, 5))])),
                                                                                        by(builtin(keysort, 2))
                                                                                      ),
                                                                                      proof(
                                                                                        goal(tour_(p(4, 5), [p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                        bindings([binding("Current", p(4, 5)), binding("Visited", [p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(3, 3)), '-'(1, p(2, 4))]), binding("__anon1", 1), binding("Best", p(2, 4)), binding("__anon2", ['-'(2, p(3, 3))])]),
                                                                                        uses([
                                                                                          proof(
                                                                                            goal(findall('-'(Degree, Next), (knight_move(p(4, 5), Next), '\\+'(member(Next, [p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(3, 3)), '-'(1, p(2, 4))])),
                                                                                            by(builtin(findall, 3))
                                                                                          ),
                                                                                          proof(
                                                                                            goal(\=(['-'(2, p(3, 3)), '-'(1, p(2, 4))], [])),
                                                                                            by(builtin(\=, 2))
                                                                                          ),
                                                                                          proof(
                                                                                            goal(keysort(['-'(2, p(3, 3)), '-'(1, p(2, 4))], ['-'(1, p(2, 4)), '-'(2, p(3, 3))])),
                                                                                            by(builtin(keysort, 2))
                                                                                          ),
                                                                                          proof(
                                                                                            goal(tour_(p(2, 4), [p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                            by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                            bindings([binding("Current", p(2, 4)), binding("Visited", [p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(2, p(1, 2))]), binding("__anon1", 2), binding("Best", p(1, 2)), binding("__anon2", [])]),
                                                                                            uses([
                                                                                              proof(
                                                                                                goal(findall('-'(Degree, Next), (knight_move(p(2, 4), Next), '\\+'(member(Next, [p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(2, p(1, 2))])),
                                                                                                by(builtin(findall, 3))
                                                                                              ),
                                                                                              proof(
                                                                                                goal(\=(['-'(2, p(1, 2))], [])),
                                                                                                by(builtin(\=, 2))
                                                                                              ),
                                                                                              proof(
                                                                                                goal(keysort(['-'(2, p(1, 2))], ['-'(2, p(1, 2))])),
                                                                                                by(builtin(keysort, 2))
                                                                                              ),
                                                                                              proof(
                                                                                                goal(tour_(p(1, 2), [p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                                by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                                bindings([binding("Current", p(1, 2)), binding("Visited", [p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(3, 3)), '-'(1, p(3, 1))]), binding("__anon1", 1), binding("Best", p(3, 3)), binding("__anon2", ['-'(1, p(3, 1))])]),
                                                                                                uses([
                                                                                                  proof(
                                                                                                    goal(findall('-'(Degree, Next), (knight_move(p(1, 2), Next), '\\+'(member(Next, [p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(3, 3)), '-'(1, p(3, 1))])),
                                                                                                    by(builtin(findall, 3))
                                                                                                  ),
                                                                                                  proof(
                                                                                                    goal(\=(['-'(1, p(3, 3)), '-'(1, p(3, 1))], [])),
                                                                                                    by(builtin(\=, 2))
                                                                                                  ),
                                                                                                  proof(
                                                                                                    goal(keysort(['-'(1, p(3, 3)), '-'(1, p(3, 1))], ['-'(1, p(3, 3)), '-'(1, p(3, 1))])),
                                                                                                    by(builtin(keysort, 2))
                                                                                                  ),
                                                                                                  proof(
                                                                                                    goal(tour_(p(3, 3), [p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                                    by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                                    bindings([binding("Current", p(3, 3)), binding("Visited", [p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(1, p(5, 2))]), binding("__anon1", 1), binding("Best", p(5, 2)), binding("__anon2", [])]),
                                                                                                    uses([
                                                                                                      proof(
                                                                                                        goal(findall('-'(Degree, Next), (knight_move(p(3, 3), Next), '\\+'(member(Next, [p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(1, p(5, 2))])),
                                                                                                        by(builtin(findall, 3))
                                                                                                      ),
                                                                                                      proof(
                                                                                                        goal(\=(['-'(1, p(5, 2))], [])),
                                                                                                        by(builtin(\=, 2))
                                                                                                      ),
                                                                                                      proof(
                                                                                                        goal(keysort(['-'(1, p(5, 2))], ['-'(1, p(5, 2))])),
                                                                                                        by(builtin(keysort, 2))
                                                                                                      ),
                                                                                                      proof(
                                                                                                        goal(tour_(p(5, 2), [p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                                        by(rule("knights-tour-warnsdorff.pl", clause(5))),
                                                                                                        bindings([binding("Current", p(5, 2)), binding("Visited", [p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25), binding("Tour", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("Candidates", ['-'(0, p(3, 1))]), binding("__anon1", 0), binding("Best", p(3, 1)), binding("__anon2", [])]),
                                                                                                        uses([
                                                                                                          proof(
                                                                                                            goal(findall('-'(Degree, Next), (knight_move(p(5, 2), Next), '\\+'(member(Next, [p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])), degree(Next, [p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], Degree)), ['-'(0, p(3, 1))])),
                                                                                                            by(builtin(findall, 3))
                                                                                                          ),
                                                                                                          proof(
                                                                                                            goal(\=(['-'(0, p(3, 1))], [])),
                                                                                                            by(builtin(\=, 2))
                                                                                                          ),
                                                                                                          proof(
                                                                                                            goal(keysort(['-'(0, p(3, 1))], ['-'(0, p(3, 1))])),
                                                                                                            by(builtin(keysort, 2))
                                                                                                          ),
                                                                                                          proof(
                                                                                                            goal(tour_(p(3, 1), [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25, [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)])),
                                                                                                            by(rule("knights-tour-warnsdorff.pl", clause(4))),
                                                                                                            bindings([binding("__anon0", p(3, 1)), binding("Visited", [p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)]), binding("SquareCount", 25)]),
                                                                                                            uses([
                                                                                                              proof(
                                                                                                                goal(length([p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], 25)),
                                                                                                                by(library(length, 2))
                                                                                                              ),
                                                                                                              proof(
                                                                                                                goal(!),
                                                                                                                by(builtin(goal, 0))
                                                                                                              )
                                                                                                            ])
                                                                                                          )
                                                                                                        ])
                                                                                                      )
                                                                                                    ])
                                                                                                  )
                                                                                                ])
                                                                                              )
                                                                                            ])
                                                                                          )
                                                                                        ])
                                                                                      )
                                                                                    ])
                                                                                  )
                                                                                ])
                                                                              )
                                                                            ])
                                                                          )
                                                                        ])
                                                                      )
                                                                    ])
                                                                  )
                                                                ])
                                                              )
                                                            ])
                                                          )
                                                        ])
                                                      )
                                                    ])
                                                  )
                                                ])
                                              )
                                            ])
                                          )
                                        ])
                                      )
                                    ])
                                  )
                                ])
                              )
                            ])
                          )
                        ])
                      )
                    ])
                  )
                ])
              )
            ])
          ),
          proof(
            goal(reverse([p(3, 1), p(5, 2), p(3, 3), p(1, 2), p(2, 4), p(4, 5), p(5, 3), p(4, 1), p(2, 2), p(1, 4), p(3, 5), p(5, 4), p(4, 2), p(2, 1), p(1, 3), p(2, 5), p(4, 4), p(3, 2), p(5, 1), p(4, 3), p(5, 5), p(3, 4), p(1, 5), p(2, 3), p(1, 1)], [p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)])),
            by(library(reverse, 2))
          )
        ])
      ),
      proof(
        goal(length([p(1, 1), p(2, 3), p(1, 5), p(3, 4), p(5, 5), p(4, 3), p(5, 1), p(3, 2), p(4, 4), p(2, 5), p(1, 3), p(2, 1), p(4, 2), p(5, 4), p(3, 5), p(1, 4), p(2, 2), p(4, 1), p(5, 3), p(4, 5), p(2, 4), p(1, 2), p(3, 3), p(5, 2), p(3, 1)], 25)),
        by(library(length, 2))
      )
    ])
  )
).

