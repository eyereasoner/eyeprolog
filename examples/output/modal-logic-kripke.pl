modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))).
modal_truth(repair_is_possible, w0, diamond(atom(repaired))).
modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))).
modal_countermodel(repair_not_necessary, w0).
