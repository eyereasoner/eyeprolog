% Prolog result format 4
query(1, violation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = alice, 'X1' = missed_obligation(obtain_consent)]).
why(1,
    ['X0' = alice, 'X1' = missed_obligation(obtain_consent)],
    [violation(alice, missed_obligation(obtain_consent))]).
answer(1, ['X0' = alice, 'X1' = prohibited_action(share_record)]).
why(1,
    ['X0' = alice, 'X1' = prohibited_action(share_record)],
    [violation(alice, prohibited_action(share_record))]).
query(2, compensation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = alice, 'X1' = compensation(share_record, notify_dpo)]).
why(2,
    ['X0' = alice, 'X1' = compensation(share_record, notify_dpo)],
    [compensation(alice, compensation(share_record, notify_dpo))]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = alice, 'X1' = requires_review]).
why(3, ['X0' = alice, 'X1' = requires_review], [status(alice, requires_review)]).

clause(4, obliged(alice, obtain_consent), true).
clause(5, prohibited(alice, share_record), true).
clause(6, compensates(share_record, notify_dpo), true).
clause(7, performed(alice, share_record), true).
clause(8, performed(alice, notify_dpo), true).
clause(9, not_performed(alice, obtain_consent), true).
clause(11,
       violation(var('Actor'), missed_obligation(var('Action'))),
       (obliged(var('Actor'), var('Action')), not_performed(var('Actor'), var('Action')))).
clause(12,
       violation(var('Actor'), prohibited_action(var('Action'))),
       (prohibited(var('Actor'), var('Action')), performed(var('Actor'), var('Action')))).
clause(13,
       compensated_violation(var('Actor'), var('Action'), var('Compensation')),
       (prohibited(var('Actor'), var('Action')),
        performed(var('Actor'), var('Action')),
        compensates(var('Action'), var('Compensation')),
        performed(var('Actor'), var('Compensation')))).
clause(14,
       uncompensated_violation(var('Actor'), missed_obligation(var('Action'))),
       violation(var('Actor'), missed_obligation(var('Action')))).
clause(16,
       compensation(var('Actor'), compensation(var('Action'), var('Compensation'))),
       compensated_violation(var('Actor'), var('Action'), var('Compensation'))).
clause(17,
       status(var('Actor'), requires_review),
       uncompensated_violation(var('Actor'), anonymous(1))).

step(violation(alice, missed_obligation(obtain_consent)),
     rule(11),
     ['Actor' = alice, 'Action' = obtain_consent],
     [obliged(alice, obtain_consent), not_performed(alice, obtain_consent)]).
step(obliged(alice, obtain_consent), fact(4), [], []).
step(not_performed(alice, obtain_consent), fact(9), [], []).
step(violation(alice, prohibited_action(share_record)),
     rule(12),
     ['Actor' = alice, 'Action' = share_record],
     [prohibited(alice, share_record), performed(alice, share_record)]).
step(prohibited(alice, share_record), fact(5), [], []).
step(performed(alice, share_record), fact(7), [], []).
step(compensation(alice, compensation(share_record, notify_dpo)),
     rule(16),
     ['Actor' = alice, 'Action' = share_record, 'Compensation' = notify_dpo],
     [compensated_violation(alice, share_record, notify_dpo)]).
step(compensated_violation(alice, share_record, notify_dpo),
     rule(13),
     ['Actor' = alice, 'Action' = share_record, 'Compensation' = notify_dpo],
     [prohibited(alice, share_record),
      performed(alice, share_record),
      compensates(share_record, notify_dpo),
      performed(alice, notify_dpo)]).
step(compensates(share_record, notify_dpo), fact(6), [], []).
step(performed(alice, notify_dpo), fact(8), [], []).
step(status(alice, requires_review),
     rule(17),
     ['Actor' = alice],
     [uncompensated_violation(alice, missed_obligation(obtain_consent))]).
step(uncompensated_violation(alice, missed_obligation(obtain_consent)),
     rule(14),
     ['Actor' = alice, 'Action' = obtain_consent],
     [violation(alice, missed_obligation(obtain_consent))]).
