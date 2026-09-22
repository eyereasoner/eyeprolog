status(case_alpha, gdpr_compliant).
why(
  status(case_alpha, gdpr_compliant),
  step(
    status(case_alpha, gdpr_compliant),
    rule("gdpr-compliance.pl", clause(25)),
    ['Case' = case_alpha],
    [
      step(
        compliant(case_alpha),
        rule("gdpr-compliance.pl", clause(20)),
        ['Case' = case_alpha],
        [
          step(processing(case_alpha), fact("gdpr-compliance.pl", clause(1)), [], []),
          step(
            has_required_basis(case_alpha),
            rule("gdpr-compliance.pl", clause(15)),
            ['Case' = case_alpha],
            [
              step(legal_basis(case_alpha, explicit_consent), fact("gdpr-compliance.pl", clause(5)), [], [])
            ]
          ),
          step(minimized(case_alpha), fact("gdpr-compliance.pl", clause(6)), [], []),
          step(
            has_health_safeguards(case_alpha),
            rule("gdpr-compliance.pl", clause(17)),
            ['Case' = case_alpha],
            [
              step(special_category(case_alpha, health_data), fact("gdpr-compliance.pl", clause(8)), [], []),
              step(safeguard(case_alpha, encryption), fact("gdpr-compliance.pl", clause(10)), [], []),
              step(safeguard(case_alpha, access_logging), fact("gdpr-compliance.pl", clause(11)), [], [])
            ]
          ),
          step(
            transfer_ok(case_alpha),
            rule("gdpr-compliance.pl", clause(18)),
            ['Case' = case_alpha],
            [
              step('\\+'(third_country_transfer(case_alpha)), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

status(case_beta, gdpr_noncompliant).
why(
  status(case_beta, gdpr_noncompliant),
  step(
    status(case_beta, gdpr_noncompliant),
    rule("gdpr-compliance.pl", clause(26)),
    ['Case' = case_beta, '_reason' = missing_legal_basis],
    [
      step(
        noncompliance_reason(case_beta, missing_legal_basis),
        rule("gdpr-compliance.pl", clause(21)),
        ['Case' = case_beta],
        [
          step(processing(case_beta), fact("gdpr-compliance.pl", clause(2)), [], []),
          step('\\+'(has_required_basis(case_beta)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

reason(case_beta, missing_legal_basis).
why(
  reason(case_beta, missing_legal_basis),
  step(
    reason(case_beta, missing_legal_basis),
    rule("gdpr-compliance.pl", clause(27)),
    ['Case' = case_beta, 'Reason' = missing_legal_basis],
    [
      step(
        noncompliance_reason(case_beta, missing_legal_basis),
        rule("gdpr-compliance.pl", clause(21)),
        ['Case' = case_beta],
        [
          step(processing(case_beta), fact("gdpr-compliance.pl", clause(2)), [], []),
          step('\\+'(has_required_basis(case_beta)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

reason(case_beta, not_minimized).
why(
  reason(case_beta, not_minimized),
  step(
    reason(case_beta, not_minimized),
    rule("gdpr-compliance.pl", clause(27)),
    ['Case' = case_beta, 'Reason' = not_minimized],
    [
      step(
        noncompliance_reason(case_beta, not_minimized),
        rule("gdpr-compliance.pl", clause(22)),
        ['Case' = case_beta],
        [
          step(not_minimized(case_beta), fact("gdpr-compliance.pl", clause(7)), [], [])
        ]
      )
    ]
  )
).

reason(case_beta, missing_access_logging).
why(
  reason(case_beta, missing_access_logging),
  step(
    reason(case_beta, missing_access_logging),
    rule("gdpr-compliance.pl", clause(27)),
    ['Case' = case_beta, 'Reason' = missing_access_logging],
    [
      step(
        noncompliance_reason(case_beta, missing_access_logging),
        rule("gdpr-compliance.pl", clause(23)),
        ['Case' = case_beta],
        [
          step(special_category(case_beta, health_data), fact("gdpr-compliance.pl", clause(9)), [], []),
          step('\\+'(safeguard(case_beta, access_logging)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

reason(case_beta, transfer_without_adequacy).
why(
  reason(case_beta, transfer_without_adequacy),
  step(
    reason(case_beta, transfer_without_adequacy),
    rule("gdpr-compliance.pl", clause(27)),
    ['Case' = case_beta, 'Reason' = transfer_without_adequacy],
    [
      step(
        noncompliance_reason(case_beta, transfer_without_adequacy),
        rule("gdpr-compliance.pl", clause(24)),
        ['Case' = case_beta],
        [
          step(third_country_transfer(case_beta), fact("gdpr-compliance.pl", clause(13)), [], []),
          step('\\+'(adequacy_decision(case_beta)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

