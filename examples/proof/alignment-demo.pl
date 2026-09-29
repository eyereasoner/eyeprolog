broader(tel_car, ref_car).
broader(tel_heavy_vehicle, ref_car).
broader(anpr_vehicle_with_plate, ref_car).
broader(anpr_passenger_car, anpr_vehicle_with_plate).
narrower(ref_car, tel_car).
narrower(ref_car, tel_heavy_vehicle).
narrower(ref_car, anpr_vehicle_with_plate).
narrower(anpr_vehicle_with_plate, anpr_passenger_car).
broaderTransitive(tel_car, ref_car).
broaderTransitive(tel_heavy_vehicle, ref_car).
broaderTransitive(anpr_vehicle_with_plate, ref_car).
broaderTransitive(anpr_passenger_car, anpr_vehicle_with_plate).
broaderTransitive(anpr_passenger_car, ref_car).
narrowerTransitive(ref_car, tel_car).
narrowerTransitive(ref_car, tel_heavy_vehicle).
narrowerTransitive(ref_car, anpr_vehicle_with_plate).
narrowerTransitive(anpr_vehicle_with_plate, anpr_passenger_car).
narrowerTransitive(ref_car, anpr_passenger_car).
narrowerOrEqualOf(ref_car, ref_car).
narrowerOrEqualOf(tel_car, tel_car).
narrowerOrEqualOf(tel_heavy_vehicle, tel_heavy_vehicle).
narrowerOrEqualOf(anpr_vehicle_with_plate, anpr_vehicle_with_plate).
narrowerOrEqualOf(anpr_passenger_car, anpr_passenger_car).
narrowerOrEqualOf(tel_car, ref_car).
narrowerOrEqualOf(tel_heavy_vehicle, ref_car).
narrowerOrEqualOf(anpr_vehicle_with_plate, ref_car).
narrowerOrEqualOf(anpr_passenger_car, anpr_vehicle_with_plate).
narrowerOrEqualOf(anpr_passenger_car, ref_car).
rollsUpTo(tel_car, ref_car).
rollsUpTo(tel_heavy_vehicle, ref_car).
rollsUpTo(anpr_vehicle_with_plate, ref_car).
rollsUpTo(anpr_passenger_car, ref_car).

clause(1, concept(ref_car), true).
clause(2, concept(tel_car), true).
clause(3, concept(tel_heavy_vehicle), true).
clause(4, concept(anpr_vehicle_with_plate), true).
clause(5, concept(anpr_passenger_car), true).
clause(6, assertedBroader(tel_car, ref_car), true).
clause(7, assertedBroader(tel_heavy_vehicle, ref_car), true).
clause(8, assertedBroader(anpr_vehicle_with_plate, ref_car), true).
clause(9, assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car), true).
clause(10, broader(var('X'), var('Y')), assertedBroader(var('X'), var('Y'))).
clause(11, broader(var('X'), var('Y')), assertedNarrower(var('Y'), var('X'))).
clause(12, narrower(var('X'), var('Y')), broader(var('Y'), var('X'))).
clause(13, broaderTransitive(var('X'), var('Y')), broader(var('X'), var('Y'))).
clause(14,
       broaderTransitive(var('X'), var('Z')),
       (broader(var('X'), var('Y')), broaderTransitive(var('Y'), var('Z')))).
clause(15, narrowerTransitive(var('X'), var('Y')), narrower(var('X'), var('Y'))).
clause(16,
       narrowerTransitive(var('X'), var('Z')),
       (narrower(var('X'), var('Y')), narrowerTransitive(var('Y'), var('Z')))).
clause(17, narrowerOrEqualOf(var('X'), var('X')), concept(var('X'))).
clause(18, narrowerOrEqualOf(var('X'), var('Y')), broaderTransitive(var('X'), var('Y'))).
clause(19,
       rollsUpTo(var('X'), ref_car),
       (narrowerOrEqualOf(var('X'), ref_car), var('X') \= ref_car)).

step(broader(tel_car, ref_car),
     rule(10),
     ['X' = tel_car, 'Y' = ref_car],
     [assertedBroader(tel_car, ref_car)]).
step(assertedBroader(tel_car, ref_car), fact(6), [], []).
step(broader(tel_heavy_vehicle, ref_car),
     rule(10),
     ['X' = tel_heavy_vehicle, 'Y' = ref_car],
     [assertedBroader(tel_heavy_vehicle, ref_car)]).
step(assertedBroader(tel_heavy_vehicle, ref_car), fact(7), [], []).
step(broader(anpr_vehicle_with_plate, ref_car),
     rule(10),
     ['X' = anpr_vehicle_with_plate, 'Y' = ref_car],
     [assertedBroader(anpr_vehicle_with_plate, ref_car)]).
step(assertedBroader(anpr_vehicle_with_plate, ref_car), fact(8), [], []).
step(broader(anpr_passenger_car, anpr_vehicle_with_plate),
     rule(11),
     ['X' = anpr_passenger_car, 'Y' = anpr_vehicle_with_plate],
     [assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car)]).
step(assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car), fact(9), [], []).
step(narrower(ref_car, tel_car),
     rule(12),
     ['X' = ref_car, 'Y' = tel_car],
     [broader(tel_car, ref_car)]).
step(narrower(ref_car, tel_heavy_vehicle),
     rule(12),
     ['X' = ref_car, 'Y' = tel_heavy_vehicle],
     [broader(tel_heavy_vehicle, ref_car)]).
step(narrower(ref_car, anpr_vehicle_with_plate),
     rule(12),
     ['X' = ref_car, 'Y' = anpr_vehicle_with_plate],
     [broader(anpr_vehicle_with_plate, ref_car)]).
step(narrower(anpr_vehicle_with_plate, anpr_passenger_car),
     rule(12),
     ['X' = anpr_vehicle_with_plate, 'Y' = anpr_passenger_car],
     [broader(anpr_passenger_car, anpr_vehicle_with_plate)]).
step(broaderTransitive(tel_car, ref_car),
     rule(13),
     ['X' = tel_car, 'Y' = ref_car],
     [broader(tel_car, ref_car)]).
step(broaderTransitive(tel_heavy_vehicle, ref_car),
     rule(13),
     ['X' = tel_heavy_vehicle, 'Y' = ref_car],
     [broader(tel_heavy_vehicle, ref_car)]).
step(broaderTransitive(anpr_vehicle_with_plate, ref_car),
     rule(13),
     ['X' = anpr_vehicle_with_plate, 'Y' = ref_car],
     [broader(anpr_vehicle_with_plate, ref_car)]).
step(broaderTransitive(anpr_passenger_car, anpr_vehicle_with_plate),
     rule(13),
     ['X' = anpr_passenger_car, 'Y' = anpr_vehicle_with_plate],
     [broader(anpr_passenger_car, anpr_vehicle_with_plate)]).
step(broaderTransitive(anpr_passenger_car, ref_car),
     rule(14),
     ['X' = anpr_passenger_car, 'Z' = ref_car, 'Y' = anpr_vehicle_with_plate],
     [broader(anpr_passenger_car, anpr_vehicle_with_plate),
      broaderTransitive(anpr_vehicle_with_plate, ref_car)]).
step(narrowerTransitive(ref_car, tel_car),
     rule(15),
     ['X' = ref_car, 'Y' = tel_car],
     [narrower(ref_car, tel_car)]).
step(narrowerTransitive(ref_car, tel_heavy_vehicle),
     rule(15),
     ['X' = ref_car, 'Y' = tel_heavy_vehicle],
     [narrower(ref_car, tel_heavy_vehicle)]).
step(narrowerTransitive(ref_car, anpr_vehicle_with_plate),
     rule(15),
     ['X' = ref_car, 'Y' = anpr_vehicle_with_plate],
     [narrower(ref_car, anpr_vehicle_with_plate)]).
step(narrowerTransitive(anpr_vehicle_with_plate, anpr_passenger_car),
     rule(15),
     ['X' = anpr_vehicle_with_plate, 'Y' = anpr_passenger_car],
     [narrower(anpr_vehicle_with_plate, anpr_passenger_car)]).
step(narrowerTransitive(ref_car, anpr_passenger_car),
     rule(16),
     ['X' = ref_car, 'Z' = anpr_passenger_car, 'Y' = anpr_vehicle_with_plate],
     [narrower(ref_car, anpr_vehicle_with_plate),
      narrowerTransitive(anpr_vehicle_with_plate, anpr_passenger_car)]).
step(narrowerOrEqualOf(ref_car, ref_car), rule(17), ['X' = ref_car], [concept(ref_car)]).
step(concept(ref_car), fact(1), [], []).
step(narrowerOrEqualOf(tel_car, tel_car), rule(17), ['X' = tel_car], [concept(tel_car)]).
step(concept(tel_car), fact(2), [], []).
step(narrowerOrEqualOf(tel_heavy_vehicle, tel_heavy_vehicle),
     rule(17),
     ['X' = tel_heavy_vehicle],
     [concept(tel_heavy_vehicle)]).
step(concept(tel_heavy_vehicle), fact(3), [], []).
step(narrowerOrEqualOf(anpr_vehicle_with_plate, anpr_vehicle_with_plate),
     rule(17),
     ['X' = anpr_vehicle_with_plate],
     [concept(anpr_vehicle_with_plate)]).
step(concept(anpr_vehicle_with_plate), fact(4), [], []).
step(narrowerOrEqualOf(anpr_passenger_car, anpr_passenger_car),
     rule(17),
     ['X' = anpr_passenger_car],
     [concept(anpr_passenger_car)]).
step(concept(anpr_passenger_car), fact(5), [], []).
step(narrowerOrEqualOf(tel_car, ref_car),
     rule(18),
     ['X' = tel_car, 'Y' = ref_car],
     [broaderTransitive(tel_car, ref_car)]).
step(narrowerOrEqualOf(tel_heavy_vehicle, ref_car),
     rule(18),
     ['X' = tel_heavy_vehicle, 'Y' = ref_car],
     [broaderTransitive(tel_heavy_vehicle, ref_car)]).
step(narrowerOrEqualOf(anpr_vehicle_with_plate, ref_car),
     rule(18),
     ['X' = anpr_vehicle_with_plate, 'Y' = ref_car],
     [broaderTransitive(anpr_vehicle_with_plate, ref_car)]).
step(narrowerOrEqualOf(anpr_passenger_car, anpr_vehicle_with_plate),
     rule(18),
     ['X' = anpr_passenger_car, 'Y' = anpr_vehicle_with_plate],
     [broaderTransitive(anpr_passenger_car, anpr_vehicle_with_plate)]).
step(narrowerOrEqualOf(anpr_passenger_car, ref_car),
     rule(18),
     ['X' = anpr_passenger_car, 'Y' = ref_car],
     [broaderTransitive(anpr_passenger_car, ref_car)]).
step(rollsUpTo(tel_car, ref_car),
     rule(19),
     ['X' = tel_car],
     [narrowerOrEqualOf(tel_car, ref_car), tel_car \= ref_car]).
step(tel_car \= ref_car, builtin, [], []).
step(rollsUpTo(tel_heavy_vehicle, ref_car),
     rule(19),
     ['X' = tel_heavy_vehicle],
     [narrowerOrEqualOf(tel_heavy_vehicle, ref_car), tel_heavy_vehicle \= ref_car]).
step(tel_heavy_vehicle \= ref_car, builtin, [], []).
step(rollsUpTo(anpr_vehicle_with_plate, ref_car),
     rule(19),
     ['X' = anpr_vehicle_with_plate],
     [narrowerOrEqualOf(anpr_vehicle_with_plate, ref_car), anpr_vehicle_with_plate \= ref_car]).
step(anpr_vehicle_with_plate \= ref_car, builtin, [], []).
step(rollsUpTo(anpr_passenger_car, ref_car),
     rule(19),
     ['X' = anpr_passenger_car],
     [narrowerOrEqualOf(anpr_passenger_car, ref_car), anpr_passenger_car \= ref_car]).
step(anpr_passenger_car \= ref_car, builtin, [], []).
