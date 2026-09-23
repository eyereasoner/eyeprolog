type(skolem_observation(alice, glucose), observation).
type(skolem_observation(alice, cholesterol), observation).
type(skolem_observation(bob, glucose), observation).
type(skolem_alert(alice, glucose), highGlucoseAlert).
patient(skolem_observation(alice, glucose), alice).
patient(skolem_observation(alice, cholesterol), alice).
patient(skolem_observation(bob, glucose), bob).
test(skolem_observation(alice, glucose), glucose).
test(skolem_observation(alice, cholesterol), cholesterol).
test(skolem_observation(bob, glucose), glucose).
value(skolem_observation(alice, glucose), 6.8).
value(skolem_observation(alice, cholesterol), 4.2).
value(skolem_observation(bob, glucose), 5.1).
about(skolem_alert(alice, glucose), skolem_observation(alice, glucose)).
sameInputsSameId(skolemDemo, true).
noObservationClash(skolemDemo, true).
