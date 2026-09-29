pointsTo(x, object_a).
pointsTo(z, object_b).
pointsTo(y, object_a).
pointsTo(r, object_b).
pointsTo(q, object_b).
heapField(object_a, object_b).
pointerFlow(load_q_from_x, object_b).
pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x").

clause(3, addr(x, object_a), true).
clause(4, addr(z, object_b), true).
clause(5, assign(y, x), true).
clause(6, store(y, z), true).
clause(7, load(q, x), true).
clause(8, assign(r, q), true).
clause(9, points_to(var('Var'), var('Object')), addr(var('Var'), var('Object'))).
clause(10,
       points_to(var('To'), var('Object')),
       (assign(var('To'), var('From')), points_to(var('From'), var('Object')))).
clause(11,
       field_points_to(var('Heap_object'), var('Value_object')),
       (store(var('Pointer'), var('Value')),
        points_to(var('Pointer'), var('Heap_object')),
        points_to(var('Value'), var('Value_object')))).
clause(12,
       points_to(var('To'), var('Value_object')),
       (load(var('To'), var('Pointer')),
        points_to(var('Pointer'), var('Heap_object')),
        field_points_to(var('Heap_object'), var('Value_object')))).
clause(13, pointsTo(var('Var'), var('Object')), points_to(var('Var'), var('Object'))).
clause(14,
       heapField(var('Heap_object'), var('Value_object')),
       field_points_to(var('Heap_object'), var('Value_object'))).
clause(15, pointerFlow(load_q_from_x, var('Object')), points_to(q, var('Object'))).
clause(16,
       pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x"),
       points_to(q, object_b)).

step(pointsTo(x, object_a),
     rule(13),
     ['Var' = x, 'Object' = object_a],
     [points_to(x, object_a)]).
step(points_to(x, object_a), rule(9), ['Var' = x, 'Object' = object_a], [addr(x, object_a)]).
step(addr(x, object_a), fact(3), [], []).
step(pointsTo(z, object_b),
     rule(13),
     ['Var' = z, 'Object' = object_b],
     [points_to(z, object_b)]).
step(points_to(z, object_b), rule(9), ['Var' = z, 'Object' = object_b], [addr(z, object_b)]).
step(addr(z, object_b), fact(4), [], []).
step(pointsTo(y, object_a),
     rule(13),
     ['Var' = y, 'Object' = object_a],
     [points_to(y, object_a)]).
step(points_to(y, object_a),
     rule(10),
     ['To' = y, 'Object' = object_a, 'From' = x],
     [assign(y, x), points_to(x, object_a)]).
step(assign(y, x), fact(5), [], []).
step(pointsTo(r, object_b),
     rule(13),
     ['Var' = r, 'Object' = object_b],
     [points_to(r, object_b)]).
step(points_to(r, object_b),
     rule(10),
     ['To' = r, 'Object' = object_b, 'From' = q],
     [assign(r, q), points_to(q, object_b)]).
step(assign(r, q), fact(8), [], []).
step(points_to(q, object_b),
     rule(12),
     ['To' = q, 'Value_object' = object_b, 'Pointer' = x, 'Heap_object' = object_a],
     [load(q, x), points_to(x, object_a), field_points_to(object_a, object_b)]).
step(load(q, x), fact(7), [], []).
step(field_points_to(object_a, object_b),
     rule(11),
     ['Heap_object' = object_a, 'Value_object' = object_b, 'Pointer' = y, 'Value' = z],
     [store(y, z), points_to(y, object_a), points_to(z, object_b)]).
step(store(y, z), fact(6), [], []).
step(pointsTo(q, object_b),
     rule(13),
     ['Var' = q, 'Object' = object_b],
     [points_to(q, object_b)]).
step(heapField(object_a, object_b),
     rule(14),
     ['Heap_object' = object_a, 'Value_object' = object_b],
     [field_points_to(object_a, object_b)]).
step(pointerFlow(load_q_from_x, object_b),
     rule(15),
     ['Object' = object_b],
     [points_to(q, object_b)]).
step(pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x"),
     rule(16),
     [],
     [points_to(q, object_b)]).
