plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc1), go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab, climb_off]).
plan(monkeyBananas, [go(loc3), push(loc2), push(loc1), climb_on, grab]).
solved(monkeyBananas, true).
