pointsTo(x, object_a).
pointsTo(z, object_b).
pointsTo(y, object_a).
pointsTo(r, object_b).
pointsTo(q, object_b).
heapField(object_a, object_b).
pointerFlow(load_q_from_x, object_b).
pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x").
