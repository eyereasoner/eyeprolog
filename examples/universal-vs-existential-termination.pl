% Universal vs. existential termination: a query terminates *existentially*
% if finding one answer (or failing outright) takes finite time; it
% terminates *universally* only if exhausting every answer does. The two
% can come apart for the very same predicate, depending only on how it is
% called -- append/3 is the classic case.
%
% append(X, Y, [a,b,c]) has exactly as many solutions as there are ways to
% split a 3-element list, so asking for all of them (findall/3) terminates:
% this call terminates universally.
%
% append(X, Y, Z) with Z left unbound has infinitely many solutions (Z can
% be a list of any length), so the first one is still found immediately
% (existential termination holds), but findall/3 over it would never
% return: this call terminates existentially but not universally. once/1
% below deliberately stops after that first solution so this file's own
% checked output stays finite -- do not replace it with findall/3.

%% goal: answer(X0, X1, X2)

answer(AllSplitsOfBoundList, SplitCount, FoundFirstSplitOfUnboundList) :-
    findall(X - Y, append(X, Y, [a, b, c]), AllSplitsOfBoundList),
    length(AllSplitsOfBoundList, SplitCount),
    % X2 comes out ground ([]), but Y2 and Z2 stay unbound (merely aliased
    % to each other) -- append/3's first solution names no particular
    % list at all, only that Y and Z must coincide. Reporting that
    % once/1 succeeded is itself the point: existential termination only
    % promises a first answer exists, not that it pins everything down.
    once((append(X2, _Y2, _Z2), X2 == [])),
    FoundFirstSplitOfUnboundList = true.
