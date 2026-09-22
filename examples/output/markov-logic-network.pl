% Prolog result format 4
query(1, mlnWeight(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = friend_smoking, 'X1' = log_weight_tenths(20)]).
answer(1, ['X0' = smoking_causes_cancer, 'X1' = log_weight_tenths(13)]).
answer(1, ['X0' = cancer_is_rare, 'X1' = log_weight_tenths(6)]).
query(2, mlnWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = w_bob_not_smokes_not_cancer, 'X1' = world(smokes(bob, no), cancer(bob, no))]).
answer(2, ['X0' = w_bob_not_smokes_cancer, 'X1' = world(smokes(bob, no), cancer(bob, yes))]).
answer(2, ['X0' = w_bob_smokes_not_cancer, 'X1' = world(smokes(bob, yes), cancer(bob, no))]).
answer(2, ['X0' = w_bob_smokes_cancer, 'X1' = world(smokes(bob, yes), cancer(bob, yes))]).
query(3, mlnSatisfied(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 7).
answer(3, ['X0' = w_bob_smokes_not_cancer, 'X1' = friend_smoking]).
answer(3, ['X0' = w_bob_smokes_cancer, 'X1' = friend_smoking]).
answer(3, ['X0' = w_bob_not_smokes_not_cancer, 'X1' = smoking_causes_cancer]).
answer(3, ['X0' = w_bob_not_smokes_cancer, 'X1' = smoking_causes_cancer]).
answer(3, ['X0' = w_bob_smokes_cancer, 'X1' = smoking_causes_cancer]).
answer(3, ['X0' = w_bob_not_smokes_not_cancer, 'X1' = cancer_is_rare]).
answer(3, ['X0' = w_bob_smokes_not_cancer, 'X1' = cancer_is_rare]).
query(4, mlnViolated(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 5).
answer(4, ['X0' = w_bob_not_smokes_not_cancer, 'X1' = friend_smoking]).
answer(4, ['X0' = w_bob_not_smokes_cancer, 'X1' = friend_smoking]).
answer(4, ['X0' = w_bob_not_smokes_cancer, 'X1' = cancer_is_rare]).
answer(4, ['X0' = w_bob_smokes_not_cancer, 'X1' = smoking_causes_cancer]).
answer(4, ['X0' = w_bob_smokes_cancer, 'X1' = cancer_is_rare]).
query(5, mlnContribution(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(5, complete, 7).
answer(5, ['X0' = w_bob_smokes_not_cancer, 'X1' = friend_smoking, 'X2' = log_weight_tenths(20)]).
answer(5, ['X0' = w_bob_smokes_cancer, 'X1' = friend_smoking, 'X2' = log_weight_tenths(20)]).
answer(5,
       ['X0' = w_bob_not_smokes_not_cancer,
        'X1' = smoking_causes_cancer,
        'X2' = log_weight_tenths(13)]).
answer(5,
       ['X0' = w_bob_not_smokes_cancer,
        'X1' = smoking_causes_cancer,
        'X2' = log_weight_tenths(13)]).
answer(5,
       ['X0' = w_bob_smokes_cancer, 'X1' = smoking_causes_cancer, 'X2' = log_weight_tenths(13)]).
answer(5,
       ['X0' = w_bob_not_smokes_not_cancer, 'X1' = cancer_is_rare, 'X2' = log_weight_tenths(6)]).
answer(5, ['X0' = w_bob_smokes_not_cancer, 'X1' = cancer_is_rare, 'X2' = log_weight_tenths(6)]).
query(6, mlnWorldScore(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 4).
answer(6, ['X0' = w_bob_not_smokes_not_cancer, 'X1' = log_weight_tenths(19)]).
answer(6, ['X0' = w_bob_not_smokes_cancer, 'X1' = log_weight_tenths(13)]).
answer(6, ['X0' = w_bob_smokes_not_cancer, 'X1' = log_weight_tenths(26)]).
answer(6, ['X0' = w_bob_smokes_cancer, 'X1' = log_weight_tenths(33)]).
query(7, mlnMapWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = w_bob_smokes_cancer, 'X1' = log_weight_tenths(33)]).
query(8, mlnConclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 1).
answer(8, ['X0' = case, 'X1' = "MAP world predicts that Bob smokes and has cancer"]).
