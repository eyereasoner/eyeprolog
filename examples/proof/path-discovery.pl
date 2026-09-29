airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague').
airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague').
airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague').

clause(1,
       route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2),
       true).
clause(2,
       airroute(var('Fromlabel'), var('Tolabel'), var('Maxstopovers'), var('Routetext')),
       (route_request(var('Fromlabel'), var('Tolabel'), var('Maxstopovers')),
        route_between(var('Fromlabel'), var('Tolabel'), var('Maxstopovers'), var('Routetext')))).
clause(3,
       route_between(var('Fromlabel'), var('Tolabel'), var('Maxstopovers'), var('Routetext')),
       (airport(var('Source'), var('Fromlabel')),
        airport(var('Destination'), var('Tolabel')),
        var('Maxlegs') is var('Maxstopovers') + 1,
        simple_path(var('Source'), var('Destination'), var('Maxlegs'), [var('Source')], var('Reversepath')),
        reverse(var('Reversepath'), var('Path')),
        route_text(var('Path'), var('Routetext')))).
clause(4,
       simple_path(var('Node'), var('Node'), anonymous(1), var('Visited'), var('Visited')),
       true).
clause(5,
       simple_path(var('Node'), var('Goal'), var('Remaininglegs'), var('Visited'), var('Path')),
       (var('Remaininglegs') > 0,
        flight(var('Node'), var('Next')),
        \+ member(var('Next'), var('Visited')),
        var('Nextremaininglegs') is var('Remaininglegs') - 1,
        simple_path(var('Next'), var('Goal'), var('Nextremaininglegs'), [var('Next') | var('Visited')], var('Path')))).
clause(6, route_text([var('Node')], var('Text')), airport(var('Node'), var('Text'))).
clause(7,
       route_text([var('Node') | var('Rest')], var('Text')),
       (var('Rest') \= [],
        airport(var('Node'), var('Label')),
        route_text(var('Rest'), var('Tail')),
        string_concat(var('Label'), ' -> ', var('Prefix')),
        string_concat(var('Prefix'), var('Tail'), var('Text')))).
clause(250,
       airport(res_airport_1452, 'Heraklion International Nikos Kazantzakis Airport'),
       true).
clause(268, airport(res_airport_1472, 'Diagoras Airport'), true).
clause(326, airport(res_airport_1587, 'Václav Havel Airport Prague'), true).
clause(1200, airport(res_airport_309, 'Liège Airport'), true).
clause(1207, airport(res_airport_310, 'Ostend-Bruges International Airport'), true).
clause(1733, airport(res_airport_3998, 'Palma De Mallorca Airport'), true).
clause(11555, flight(res_airport_1452, res_airport_1587), true).
clause(11829, flight(res_airport_1472, res_airport_1587), true).
clause(23517, flight(res_airport_309, res_airport_1452), true).
clause(23518, flight(res_airport_309, res_airport_1472), true).
clause(23519, flight(res_airport_309, res_airport_3998), true).
clause(23630, flight(res_airport_310, res_airport_309), true).
clause(35453, flight(res_airport_3998, res_airport_1587), true).

step(airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     rule(2),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'],
     [route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2),
      route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague')]).
step(route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2),
     fact(1),
     [],
     []).
step(route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     rule(3),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Source' = res_airport_310,
      'Destination' = res_airport_1587,
      'Maxlegs' = 3,
      'Reversepath' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310],
      'Path' = [res_airport_310, res_airport_309, res_airport_1452, res_airport_1587]],
     [airport(res_airport_310, 'Ostend-Bruges International Airport'),
      airport(res_airport_1587, 'Václav Havel Airport Prague'),
      3 is 2 + 1,
      simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
      reverse([res_airport_1587, res_airport_1452, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_1452, res_airport_1587]),
      route_text([res_airport_310, res_airport_309, res_airport_1452, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague')]).
step(airport(res_airport_310, 'Ostend-Bruges International Airport'), fact(1207), [], []).
step(airport(res_airport_1587, 'Václav Havel Airport Prague'), fact(326), [], []).
step(3 is 2 + 1, builtin, [], []).
step(simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_310,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 3,
      'Visited' = [res_airport_310],
      'Path' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310],
      'Next' = res_airport_309,
      'Nextremaininglegs' = 2],
     [3 > 0,
      flight(res_airport_310, res_airport_309),
      \+ member(res_airport_309, [res_airport_310]),
      2 is 3 - 1,
      simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310])]).
step(3 > 0, builtin, [], []).
step(flight(res_airport_310, res_airport_309), fact(23630), [], []).
step(\+ member(res_airport_309, [res_airport_310]), absent, [], []).
step(2 is 3 - 1, builtin, [], []).
step(simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_309,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 2,
      'Visited' = [res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310],
      'Next' = res_airport_1452,
      'Nextremaininglegs' = 1],
     [2 > 0,
      flight(res_airport_309, res_airport_1452),
      \+ member(res_airport_1452, [res_airport_309, res_airport_310]),
      1 is 2 - 1,
      simple_path(res_airport_1452, res_airport_1587, 1, [res_airport_1452, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310])]).
step(2 > 0, builtin, [], []).
step(flight(res_airport_309, res_airport_1452), fact(23517), [], []).
step(\+ member(res_airport_1452, [res_airport_309, res_airport_310]), absent, [], []).
step(1 is 2 - 1, builtin, [], []).
step(simple_path(res_airport_1452, res_airport_1587, 1, [res_airport_1452, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_1452,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 1,
      'Visited' = [res_airport_1452, res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310],
      'Next' = res_airport_1587,
      'Nextremaininglegs' = 0],
     [1 > 0,
      flight(res_airport_1452, res_airport_1587),
      \+ member(res_airport_1587, [res_airport_1452, res_airport_309, res_airport_310]),
      0 is 1 - 1,
      simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310])]).
step(1 > 0, builtin, [], []).
step(flight(res_airport_1452, res_airport_1587), fact(11555), [], []).
step(\+ member(res_airport_1587, [res_airport_1452, res_airport_309, res_airport_310]),
     absent,
     [],
     []).
step(0 is 1 - 1, builtin, [], []).
step(simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]),
     fact(4),
     ['Node' = res_airport_1587,
      'Visited' = [res_airport_1587, res_airport_1452, res_airport_309, res_airport_310]],
     []).
step(reverse([res_airport_1587, res_airport_1452, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_1452, res_airport_1587]),
     builtin,
     [],
     []).
step(route_text([res_airport_310, res_airport_309, res_airport_1452, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_310,
      'Rest' = [res_airport_309, res_airport_1452, res_airport_1587],
      'Text' = 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Label' = 'Ostend-Bruges International Airport',
      'Tail' = 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Ostend-Bruges International Airport -> '],
     [[res_airport_309, res_airport_1452, res_airport_1587] \= [],
      airport(res_airport_310, 'Ostend-Bruges International Airport'),
      route_text([res_airport_309, res_airport_1452, res_airport_1587], 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
      string_concat('Ostend-Bruges International Airport', ' -> ', 'Ostend-Bruges International Airport -> '),
      string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague')]).
step([res_airport_309, res_airport_1452, res_airport_1587] \= [], builtin, [], []).
step(route_text([res_airport_309, res_airport_1452, res_airport_1587], 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_309,
      'Rest' = [res_airport_1452, res_airport_1587],
      'Text' = 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Label' = 'Liège Airport',
      'Tail' = 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Liège Airport -> '],
     [[res_airport_1452, res_airport_1587] \= [],
      airport(res_airport_309, 'Liège Airport'),
      route_text([res_airport_1452, res_airport_1587], 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
      string_concat('Liège Airport', ' -> ', 'Liège Airport -> '),
      string_concat('Liège Airport -> ', 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague', 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague')]).
step([res_airport_1452, res_airport_1587] \= [], builtin, [], []).
step(airport(res_airport_309, 'Liège Airport'), fact(1200), [], []).
step(route_text([res_airport_1452, res_airport_1587], 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_1452,
      'Rest' = [res_airport_1587],
      'Text' = 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague',
      'Label' = 'Heraklion International Nikos Kazantzakis Airport',
      'Tail' = 'Václav Havel Airport Prague',
      'Prefix' = 'Heraklion International Nikos Kazantzakis Airport -> '],
     [[res_airport_1587] \= [],
      airport(res_airport_1452, 'Heraklion International Nikos Kazantzakis Airport'),
      route_text([res_airport_1587], 'Václav Havel Airport Prague'),
      string_concat('Heraklion International Nikos Kazantzakis Airport', ' -> ', 'Heraklion International Nikos Kazantzakis Airport -> '),
      string_concat('Heraklion International Nikos Kazantzakis Airport -> ', 'Václav Havel Airport Prague', 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague')]).
step([res_airport_1587] \= [], builtin, [], []).
step(airport(res_airport_1452, 'Heraklion International Nikos Kazantzakis Airport'),
     fact(250),
     [],
     []).
step(route_text([res_airport_1587], 'Václav Havel Airport Prague'),
     rule(6),
     ['Node' = res_airport_1587, 'Text' = 'Václav Havel Airport Prague'],
     [airport(res_airport_1587, 'Václav Havel Airport Prague')]).
step(string_concat('Heraklion International Nikos Kazantzakis Airport', ' -> ', 'Heraklion International Nikos Kazantzakis Airport -> '),
     builtin,
     [],
     []).
step(string_concat('Heraklion International Nikos Kazantzakis Airport -> ', 'Václav Havel Airport Prague', 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Liège Airport', ' -> ', 'Liège Airport -> '), builtin, [], []).
step(string_concat('Liège Airport -> ', 'Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague', 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Ostend-Bruges International Airport', ' -> ', 'Ostend-Bruges International Airport -> '),
     builtin,
     [],
     []).
step(string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Heraklion International Nikos Kazantzakis Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     rule(2),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'],
     [route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2),
      route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague')]).
step(route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     rule(3),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague',
      'Source' = res_airport_310,
      'Destination' = res_airport_1587,
      'Maxlegs' = 3,
      'Reversepath' = [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310],
      'Path' = [res_airport_310, res_airport_309, res_airport_1472, res_airport_1587]],
     [airport(res_airport_310, 'Ostend-Bruges International Airport'),
      airport(res_airport_1587, 'Václav Havel Airport Prague'),
      3 is 2 + 1,
      simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]),
      reverse([res_airport_1587, res_airport_1472, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_1472, res_airport_1587]),
      route_text([res_airport_310, res_airport_309, res_airport_1472, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague')]).
step(simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_310,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 3,
      'Visited' = [res_airport_310],
      'Path' = [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310],
      'Next' = res_airport_309,
      'Nextremaininglegs' = 2],
     [3 > 0,
      flight(res_airport_310, res_airport_309),
      \+ member(res_airport_309, [res_airport_310]),
      2 is 3 - 1,
      simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310])]).
step(simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_309,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 2,
      'Visited' = [res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310],
      'Next' = res_airport_1472,
      'Nextremaininglegs' = 1],
     [2 > 0,
      flight(res_airport_309, res_airport_1472),
      \+ member(res_airport_1472, [res_airport_309, res_airport_310]),
      1 is 2 - 1,
      simple_path(res_airport_1472, res_airport_1587, 1, [res_airport_1472, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310])]).
step(flight(res_airport_309, res_airport_1472), fact(23518), [], []).
step(\+ member(res_airport_1472, [res_airport_309, res_airport_310]), absent, [], []).
step(simple_path(res_airport_1472, res_airport_1587, 1, [res_airport_1472, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_1472,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 1,
      'Visited' = [res_airport_1472, res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310],
      'Next' = res_airport_1587,
      'Nextremaininglegs' = 0],
     [1 > 0,
      flight(res_airport_1472, res_airport_1587),
      \+ member(res_airport_1587, [res_airport_1472, res_airport_309, res_airport_310]),
      0 is 1 - 1,
      simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310])]).
step(flight(res_airport_1472, res_airport_1587), fact(11829), [], []).
step(\+ member(res_airport_1587, [res_airport_1472, res_airport_309, res_airport_310]),
     absent,
     [],
     []).
step(simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310], [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]),
     fact(4),
     ['Node' = res_airport_1587,
      'Visited' = [res_airport_1587, res_airport_1472, res_airport_309, res_airport_310]],
     []).
step(reverse([res_airport_1587, res_airport_1472, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_1472, res_airport_1587]),
     builtin,
     [],
     []).
step(route_text([res_airport_310, res_airport_309, res_airport_1472, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_310,
      'Rest' = [res_airport_309, res_airport_1472, res_airport_1587],
      'Text' = 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague',
      'Label' = 'Ostend-Bruges International Airport',
      'Tail' = 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Ostend-Bruges International Airport -> '],
     [[res_airport_309, res_airport_1472, res_airport_1587] \= [],
      airport(res_airport_310, 'Ostend-Bruges International Airport'),
      route_text([res_airport_309, res_airport_1472, res_airport_1587], 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
      string_concat('Ostend-Bruges International Airport', ' -> ', 'Ostend-Bruges International Airport -> '),
      string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague')]).
step([res_airport_309, res_airport_1472, res_airport_1587] \= [], builtin, [], []).
step(route_text([res_airport_309, res_airport_1472, res_airport_1587], 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_309,
      'Rest' = [res_airport_1472, res_airport_1587],
      'Text' = 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague',
      'Label' = 'Liège Airport',
      'Tail' = 'Diagoras Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Liège Airport -> '],
     [[res_airport_1472, res_airport_1587] \= [],
      airport(res_airport_309, 'Liège Airport'),
      route_text([res_airport_1472, res_airport_1587], 'Diagoras Airport -> Václav Havel Airport Prague'),
      string_concat('Liège Airport', ' -> ', 'Liège Airport -> '),
      string_concat('Liège Airport -> ', 'Diagoras Airport -> Václav Havel Airport Prague', 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague')]).
step([res_airport_1472, res_airport_1587] \= [], builtin, [], []).
step(route_text([res_airport_1472, res_airport_1587], 'Diagoras Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_1472,
      'Rest' = [res_airport_1587],
      'Text' = 'Diagoras Airport -> Václav Havel Airport Prague',
      'Label' = 'Diagoras Airport',
      'Tail' = 'Václav Havel Airport Prague',
      'Prefix' = 'Diagoras Airport -> '],
     [[res_airport_1587] \= [],
      airport(res_airport_1472, 'Diagoras Airport'),
      route_text([res_airport_1587], 'Václav Havel Airport Prague'),
      string_concat('Diagoras Airport', ' -> ', 'Diagoras Airport -> '),
      string_concat('Diagoras Airport -> ', 'Václav Havel Airport Prague', 'Diagoras Airport -> Václav Havel Airport Prague')]).
step(airport(res_airport_1472, 'Diagoras Airport'), fact(268), [], []).
step(string_concat('Diagoras Airport', ' -> ', 'Diagoras Airport -> '), builtin, [], []).
step(string_concat('Diagoras Airport -> ', 'Václav Havel Airport Prague', 'Diagoras Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Liège Airport -> ', 'Diagoras Airport -> Václav Havel Airport Prague', 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Diagoras Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     rule(2),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'],
     [route_request('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2),
      route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague')]).
step(route_between('Ostend-Bruges International Airport', 'Václav Havel Airport Prague', 2, 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     rule(3),
     ['Fromlabel' = 'Ostend-Bruges International Airport',
      'Tolabel' = 'Václav Havel Airport Prague',
      'Maxstopovers' = 2,
      'Routetext' = 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Source' = res_airport_310,
      'Destination' = res_airport_1587,
      'Maxlegs' = 3,
      'Reversepath' = [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310],
      'Path' = [res_airport_310, res_airport_309, res_airport_3998, res_airport_1587]],
     [airport(res_airport_310, 'Ostend-Bruges International Airport'),
      airport(res_airport_1587, 'Václav Havel Airport Prague'),
      3 is 2 + 1,
      simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]),
      reverse([res_airport_1587, res_airport_3998, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_3998, res_airport_1587]),
      route_text([res_airport_310, res_airport_309, res_airport_3998, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague')]).
step(simple_path(res_airport_310, res_airport_1587, 3, [res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_310,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 3,
      'Visited' = [res_airport_310],
      'Path' = [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310],
      'Next' = res_airport_309,
      'Nextremaininglegs' = 2],
     [3 > 0,
      flight(res_airport_310, res_airport_309),
      \+ member(res_airport_309, [res_airport_310]),
      2 is 3 - 1,
      simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310])]).
step(simple_path(res_airport_309, res_airport_1587, 2, [res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_309,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 2,
      'Visited' = [res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310],
      'Next' = res_airport_3998,
      'Nextremaininglegs' = 1],
     [2 > 0,
      flight(res_airport_309, res_airport_3998),
      \+ member(res_airport_3998, [res_airport_309, res_airport_310]),
      1 is 2 - 1,
      simple_path(res_airport_3998, res_airport_1587, 1, [res_airport_3998, res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310])]).
step(flight(res_airport_309, res_airport_3998), fact(23519), [], []).
step(\+ member(res_airport_3998, [res_airport_309, res_airport_310]), absent, [], []).
step(simple_path(res_airport_3998, res_airport_1587, 1, [res_airport_3998, res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]),
     rule(5),
     ['Node' = res_airport_3998,
      'Goal' = res_airport_1587,
      'Remaininglegs' = 1,
      'Visited' = [res_airport_3998, res_airport_309, res_airport_310],
      'Path' = [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310],
      'Next' = res_airport_1587,
      'Nextremaininglegs' = 0],
     [1 > 0,
      flight(res_airport_3998, res_airport_1587),
      \+ member(res_airport_1587, [res_airport_3998, res_airport_309, res_airport_310]),
      0 is 1 - 1,
      simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310])]).
step(flight(res_airport_3998, res_airport_1587), fact(35453), [], []).
step(\+ member(res_airport_1587, [res_airport_3998, res_airport_309, res_airport_310]),
     absent,
     [],
     []).
step(simple_path(res_airport_1587, res_airport_1587, 0, [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310], [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]),
     fact(4),
     ['Node' = res_airport_1587,
      'Visited' = [res_airport_1587, res_airport_3998, res_airport_309, res_airport_310]],
     []).
step(reverse([res_airport_1587, res_airport_3998, res_airport_309, res_airport_310], [res_airport_310, res_airport_309, res_airport_3998, res_airport_1587]),
     builtin,
     [],
     []).
step(route_text([res_airport_310, res_airport_309, res_airport_3998, res_airport_1587], 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_310,
      'Rest' = [res_airport_309, res_airport_3998, res_airport_1587],
      'Text' = 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Label' = 'Ostend-Bruges International Airport',
      'Tail' = 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Ostend-Bruges International Airport -> '],
     [[res_airport_309, res_airport_3998, res_airport_1587] \= [],
      airport(res_airport_310, 'Ostend-Bruges International Airport'),
      route_text([res_airport_309, res_airport_3998, res_airport_1587], 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
      string_concat('Ostend-Bruges International Airport', ' -> ', 'Ostend-Bruges International Airport -> '),
      string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague')]).
step([res_airport_309, res_airport_3998, res_airport_1587] \= [], builtin, [], []).
step(route_text([res_airport_309, res_airport_3998, res_airport_1587], 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_309,
      'Rest' = [res_airport_3998, res_airport_1587],
      'Text' = 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Label' = 'Liège Airport',
      'Tail' = 'Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Prefix' = 'Liège Airport -> '],
     [[res_airport_3998, res_airport_1587] \= [],
      airport(res_airport_309, 'Liège Airport'),
      route_text([res_airport_3998, res_airport_1587], 'Palma De Mallorca Airport -> Václav Havel Airport Prague'),
      string_concat('Liège Airport', ' -> ', 'Liège Airport -> '),
      string_concat('Liège Airport -> ', 'Palma De Mallorca Airport -> Václav Havel Airport Prague', 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague')]).
step([res_airport_3998, res_airport_1587] \= [], builtin, [], []).
step(route_text([res_airport_3998, res_airport_1587], 'Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     rule(7),
     ['Node' = res_airport_3998,
      'Rest' = [res_airport_1587],
      'Text' = 'Palma De Mallorca Airport -> Václav Havel Airport Prague',
      'Label' = 'Palma De Mallorca Airport',
      'Tail' = 'Václav Havel Airport Prague',
      'Prefix' = 'Palma De Mallorca Airport -> '],
     [[res_airport_1587] \= [],
      airport(res_airport_3998, 'Palma De Mallorca Airport'),
      route_text([res_airport_1587], 'Václav Havel Airport Prague'),
      string_concat('Palma De Mallorca Airport', ' -> ', 'Palma De Mallorca Airport -> '),
      string_concat('Palma De Mallorca Airport -> ', 'Václav Havel Airport Prague', 'Palma De Mallorca Airport -> Václav Havel Airport Prague')]).
step(airport(res_airport_3998, 'Palma De Mallorca Airport'), fact(1733), [], []).
step(string_concat('Palma De Mallorca Airport', ' -> ', 'Palma De Mallorca Airport -> '),
     builtin,
     [],
     []).
step(string_concat('Palma De Mallorca Airport -> ', 'Václav Havel Airport Prague', 'Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Liège Airport -> ', 'Palma De Mallorca Airport -> Václav Havel Airport Prague', 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
step(string_concat('Ostend-Bruges International Airport -> ', 'Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague', 'Ostend-Bruges International Airport -> Liège Airport -> Palma De Mallorca Airport -> Václav Havel Airport Prague'),
     builtin,
     [],
     []).
