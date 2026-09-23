sharing_decision(marketing, deny).
sharing_decision(research_us, review).
sharing_decision(research_eu, permit).
obligation(research_eu, delete_after_days(120)).
obligation(research_eu, retain_audit_log).
decision_reason(research_eu, "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region.").
decision_reason(marketing, "The requested marketing distribution matches an explicit ODRL prohibition.").
decision_reason(research_us, "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed.").
