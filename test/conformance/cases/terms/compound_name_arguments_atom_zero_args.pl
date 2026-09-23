% compound_name_arguments/3 observes atoms as name plus empty argument list.
%% ?- answer(X0, X1).

answer(Name, Args) :- (nil =.. [Name | Args]).
