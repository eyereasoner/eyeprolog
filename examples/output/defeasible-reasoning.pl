reimbursementQuestion(plain, taxi_receipt, true).
reimbursementQuestion(alcohol_excluded, client_dinner_wine, false).
reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true).
conflictQuestion(blanket_allowance, team_offsite_hotel, undefined).
conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined).
explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement).
