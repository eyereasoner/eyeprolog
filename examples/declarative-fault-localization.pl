% Declarative fault localization: when a predicate returns a wrong answer,
% test it again on a strictly smaller sub-goal that a correct version would
% still have to get right. Each step either still shows the wrong answer
% (the fault is at or before this depth -- keep shrinking) or the sub-goal
% is fine (the fault must be in what combines that correct sub-result with
% the rest). No stack trace or print statement is needed: only whether each
% successively smaller call is itself correct.
%
% buggy_list_max/2 has its comparison branches swapped in the recursive
% clause (a classic off-by-one-style slip), so it sometimes reports the
% smaller of two candidates as the maximum.
buggy_list_max([X], X).
buggy_list_max([X|Xs], Max) :-
    buggy_list_max(Xs, Max0),
    ( X > Max0 -> Max = Max0 ; Max = X ).

fixed_list_max([X], X).
fixed_list_max([X|Xs], Max) :-
    fixed_list_max(Xs, Max0),
    ( X > Max0 -> Max = X ; Max = Max0 ).

%% goal: answer(X0, X1, X2, X3)

answer(WholeListWrongAnswer, TwoElementSublistAlreadyWrong, BaseCaseIsCorrect, FixedAnswer) :-
    % The full query already gives the wrong maximum...
    buggy_list_max([1, 5, 3], WholeListWrongAnswer),
    % ...and so, it turns out, does the very first recursive step alone:
    % this two-element call is already wrong on its own, which localizes
    % the fault to the recursive clause itself, not to how its result
    % later combines with the outer 1.
    buggy_list_max([5, 3], TwoElementSublistAlreadyWrong),
    % Shrinking one step further reaches the base case, which is correct
    % (trivially): the fault cannot be shrunk past this depth.
    buggy_list_max([3], BaseCaseIsCorrect),
    % Swapping the branches back gives the right answer throughout.
    fixed_list_max([1, 5, 3], FixedAnswer).
