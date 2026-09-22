violation(alice, missed_obligation(obtain_consent)).
why(
  violation(alice, missed_obligation(obtain_consent)),
  step(
    violation(alice, missed_obligation(obtain_consent)),
    rule("deontic-logic.pl", clause(11)),
    ['Actor' = alice, 'Action' = obtain_consent],
    [
      step(obliged(alice, obtain_consent), fact("deontic-logic.pl", clause(4)), [], []),
      step(not_performed(alice, obtain_consent), fact("deontic-logic.pl", clause(9)), [], [])
    ]
  )
).

violation(alice, prohibited_action(share_record)).
why(
  violation(alice, prohibited_action(share_record)),
  step(
    violation(alice, prohibited_action(share_record)),
    rule("deontic-logic.pl", clause(12)),
    ['Actor' = alice, 'Action' = share_record],
    [
      step(prohibited(alice, share_record), fact("deontic-logic.pl", clause(5)), [], []),
      step(performed(alice, share_record), fact("deontic-logic.pl", clause(7)), [], [])
    ]
  )
).

compensation(alice, compensation(share_record, notify_dpo)).
why(
  compensation(alice, compensation(share_record, notify_dpo)),
  step(
    compensation(alice, compensation(share_record, notify_dpo)),
    rule("deontic-logic.pl", clause(16)),
    ['Actor' = alice, 'Action' = share_record, 'Compensation' = notify_dpo],
    [
      step(
        compensated_violation(alice, share_record, notify_dpo),
        rule("deontic-logic.pl", clause(13)),
        ['Actor' = alice, 'Action' = share_record, 'Compensation' = notify_dpo],
        [
          step(prohibited(alice, share_record), fact("deontic-logic.pl", clause(5)), [], []),
          step(performed(alice, share_record), fact("deontic-logic.pl", clause(7)), [], []),
          step(compensates(share_record, notify_dpo), fact("deontic-logic.pl", clause(6)), [], []),
          step(performed(alice, notify_dpo), fact("deontic-logic.pl", clause(8)), [], [])
        ]
      )
    ]
  )
).

status(alice, requires_review).
why(
  status(alice, requires_review),
  step(
    status(alice, requires_review),
    rule("deontic-logic.pl", clause(17)),
    ['Actor' = alice, '_violation' = missed_obligation(obtain_consent)],
    [
      step(
        uncompensated_violation(alice, missed_obligation(obtain_consent)),
        rule("deontic-logic.pl", clause(14)),
        ['Actor' = alice, 'Action' = obtain_consent],
        [
          step(
            violation(alice, missed_obligation(obtain_consent)),
            rule("deontic-logic.pl", clause(11)),
            ['Actor' = alice, 'Action' = obtain_consent],
            [
              step(obliged(alice, obtain_consent), fact("deontic-logic.pl", clause(4)), [], []),
              step(not_performed(alice, obtain_consent), fact("deontic-logic.pl", clause(9)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

