# Microgrid dispatch

## How should a campus cover its load with renewables, a battery, and the grid?

A campus microgrid needs 620 kW. Solar and wind cover part of it; the battery
can cover more, but must keep a reserve; the grid covers the rest, up to a
contract limit. EyeProlog computes the dispatch and states whether every
constraint holds.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=microgrid-dispatch) ·
[Source](../microgrid-dispatch.pl)

---

# The question

The dispatch policy is simple and auditable:

1. use renewables first;
2. discharge the battery, but never below its required reserve;
3. import whatever is still missing from the grid.

Is the resulting plan stable, meaning within the grid contract and with the
reserve intact?

---

# The facts

```prolog
load_kW(campus_interval_17, 620.0).
solar_kW(campus_interval_17, 180.0).
wind_kW(campus_interval_17, 90.0).
battery_max_discharge_kW(campus_interval_17, 320.0).
required_battery_reserve_kW(campus_interval_17, 80.0).
grid_contract_limit_kW(campus_interval_17, 150.0).
```

One 15-minute-style planning interval with all quantities in kilowatts.

---

# The rules

```prolog
battery_dispatch_kW(Site, Dispatch) :-
  net_deficit_kW(Site, Deficit),
  reserve_aware_battery_limit_kW(Site, Limit),
  (Deficit =< Limit -> Dispatch = Deficit ; Dispatch = Limit).

grid_import_kW(Site, Import) :-
  net_deficit_kW(Site, Deficit),
  battery_dispatch_kW(Site, Dispatch),
  (Import is Deficit - Dispatch).

stable_dispatch(Site) :-
  contract_ok(Site),
  reserve_ok(Site).
```

The battery covers the deficit up to its reserve-aware limit; the grid imports
the rest. The plan is stable only if both the contract and the reserve checks
pass.

---

# The answer

```sh
eyeprolog examples/microgrid-dispatch.pl
```

```text
renewablePower_kW(campus_interval_17, 270.0).
batteryDispatch_kW(campus_interval_17, 240.0).
gridImport_kW(campus_interval_17, 110.0).
reserveAfterDispatch_kW(campus_interval_17, 80.0).
status(campus_interval_17, stable_dispatch).
reason(campus_interval_17, "battery dispatch covers the deficit while preserving reserve and grid contract limits").
```

Renewables give 270 kW, leaving a 350 kW deficit. The battery supplies
240 kW (its 320 kW maximum minus the 80 kW reserve), and the grid imports the
remaining 110 kW, under the 150 kW contract.

---

# The reason

```text
step(battery_dispatch_kW(campus_interval_17, 240.0),
     rule(11),
     ['Site' = campus_interval_17, 'Dispatch' = 240.0, 'Deficit' = 350.0, 'Limit' = 240.0],
     [net_deficit_kW(campus_interval_17, 350.0),
      reserve_aware_battery_limit_kW(campus_interval_17, 240.0),
      (350.0 =< 240.0 -> 240.0 = 350.0 ; 240.0 = 240.0)]).
step(contract_ok(campus_interval_17),
     rule(14),
     ['Site' = campus_interval_17, 'Import' = 110.0, 'Limit' = 150.0],
     [grid_import_kW(campus_interval_17, 110.0),
      grid_contract_limit_kW(campus_interval_17, 150.0),
      110.0 =< 150.0]).
```

The deficit (350) exceeds the battery limit (240), so the if-then-else takes
the limit. The grid import of 110 kW is then within the 150 kW contract.

---

# The check

```text
condition('C1', resolution, ok, 21).
condition('C5', re_decision, ok, 10).
steps(31).
verified(21).
recomputed(9).
composed(1).
trusted(0).
verdict(checked).
```

Every rule step replays and every arithmetic step is recomputed. The one
if-then-else decision is recorded as the branch it took, including the failed
test `\+ 350.0 =< 240.0`, which the checker decides again too. The plan's
feasibility is fully checked.

---

# Try it

- Raise the load to 700 kW. Which constraint fails first, and what happens to
  `status/2`?
- Add a rule that reports *why* a dispatch is unstable, naming the failed
  constraint.
- Lower `required_battery_reserve_kW` to 0. Is the plan more robust or less,
  and does the model say so?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
