safeInWorld(city_errand, w1).
safeInWorld(city_errand, w2).
safeInWorld(city_errand, w0).
safeInWorld(city_errand, w3).
safeInWorld(winter_highway, w1).
safeInWorld(heavy_delivery, w1).
safeInWorld(heavy_delivery, w2).
safeInWorld(heavy_delivery, w0).
safeInWorld(cold_commute, w1).
safeInWorld(cold_commute, w2).
safeInWorld(cold_commute, w0).
safeInWorld(cold_commute, w3).
riskyInWorld(winter_highway, w2).
riskyInWorld(winter_highway, w0).
riskyInWorld(winter_highway, w3).
riskyInWorld(heavy_delivery, w3).
reason(winter_highway, "cold fast payload trip exceeds battery in physics-aware worlds").
reason(heavy_delivery, "safety buffer turns a physics-safe delivery into a cautious risk").
status(ev_range_worlds, expected_world_pattern).
