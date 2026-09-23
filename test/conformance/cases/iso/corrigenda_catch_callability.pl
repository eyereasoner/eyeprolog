% Corrigendum 2: conversion/execution errors of catch/3's protected goal are catchable.
%% ?- corrigenda_catch_callability(ok).

corrigenda_catch_callability(ok) :-
    catch(Goal, error(instantiation_error, _), true),
    var(Goal),
    catch(call(1), error(type_error(callable, 1), _), true).
