safeInWorld(city_dry, w0).
safeInWorld(city_dry, w1).
safeInWorld(city_dry, w2).
safeInWorld(city_dry, w3).
safeInWorld(highway_dry_short_gap, w1).
safeInWorld(highway_dry_short_gap, w2).
safeInWorld(city_wet, w0).
safeInWorld(city_wet, w1).
safeInWorld(city_wet, w2).
safeInWorld(city_ice, w2).
riskyInWorld(highway_dry_short_gap, w0).
riskyInWorld(highway_dry_short_gap, w3).
riskyInWorld(city_wet, w3).
riskyInWorld(city_ice, w0).
riskyInWorld(city_ice, w1).
riskyInWorld(city_ice, w3).
status(braking_safety_worlds, expected_world_pattern).
reason(braking_safety_worlds, "simplified and naive worlds can be optimistic while the cautious world tightens the reference model").
