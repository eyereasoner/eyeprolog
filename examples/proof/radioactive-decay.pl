halfLivesElapsed(iodine_sample, 2.0).
remainingActivity_Bq(iodine_sample, 20.0).
decayedActivity_Bq(iodine_sample, 60.0).
status(iodine_sample, low_activity).
reason(iodine_sample, "two half-lives leave one quarter of the initial activity").

clause(1, sample(iodine_sample, initial_activity_bq, 80.0), true).
clause(2, sample(iodine_sample, half_life_h, 8.0), true).
clause(3, sample(iodine_sample, elapsed_h, 16.0), true).
clause(4, threshold(iodine_sample, low_activity_bq, 25.0), true).
clause(5,
       half_lives(var('Sample'), var('Count')),
       (sample(var('Sample'), elapsed_h, var('Elapsed')),
        sample(var('Sample'), half_life_h, var('Halflife')),
        var('Count') is var('Elapsed') / var('Halflife'))).
clause(6,
       remaining_fraction(var('Sample'), var('Fraction')),
       (half_lives(var('Sample'), var('Count')), var('Fraction') is 0.5 ** var('Count'))).
clause(7,
       remaining_activity(var('Sample'), var('Remaining')),
       (sample(var('Sample'), initial_activity_bq, var('Initial')),
        remaining_fraction(var('Sample'), var('Fraction')),
        var('Remaining') is var('Initial') * var('Fraction'))).
clause(8,
       decayed_activity(var('Sample'), var('Decayed')),
       (sample(var('Sample'), initial_activity_bq, var('Initial')),
        remaining_activity(var('Sample'), var('Remaining')),
        var('Decayed') is var('Initial') - var('Remaining'))).
clause(9,
       low_activity(var('Sample')),
       (remaining_activity(var('Sample'), var('Remaining')),
        threshold(var('Sample'), low_activity_bq, var('Limit')),
        var('Remaining') < var('Limit'))).
clause(10,
       halfLivesElapsed(var('Sample'), var('Count')),
       half_lives(var('Sample'), var('Count'))).
clause(11,
       remainingActivity_Bq(var('Sample'), var('Remaining')),
       remaining_activity(var('Sample'), var('Remaining'))).
clause(12,
       decayedActivity_Bq(var('Sample'), var('Decayed')),
       decayed_activity(var('Sample'), var('Decayed'))).
clause(13, status(var('Sample'), low_activity), low_activity(var('Sample'))).
clause(14,
       reason(var('Sample'), "two half-lives leave one quarter of the initial activity"),
       low_activity(var('Sample'))).

step(halfLivesElapsed(iodine_sample, 2.0),
     rule(10),
     ['Sample' = iodine_sample, 'Count' = 2.0],
     [half_lives(iodine_sample, 2.0)]).
step(half_lives(iodine_sample, 2.0),
     rule(5),
     ['Sample' = iodine_sample, 'Count' = 2.0, 'Elapsed' = 16.0, 'Halflife' = 8.0],
     [sample(iodine_sample, elapsed_h, 16.0),
      sample(iodine_sample, half_life_h, 8.0),
      2.0 is 16.0 / 8.0]).
step(sample(iodine_sample, elapsed_h, 16.0), fact(3), [], []).
step(sample(iodine_sample, half_life_h, 8.0), fact(2), [], []).
step(2.0 is 16.0 / 8.0, builtin, [], []).
step(remainingActivity_Bq(iodine_sample, 20.0),
     rule(11),
     ['Sample' = iodine_sample, 'Remaining' = 20.0],
     [remaining_activity(iodine_sample, 20.0)]).
step(remaining_activity(iodine_sample, 20.0),
     rule(7),
     ['Sample' = iodine_sample, 'Remaining' = 20.0, 'Initial' = 80.0, 'Fraction' = 0.25],
     [sample(iodine_sample, initial_activity_bq, 80.0),
      remaining_fraction(iodine_sample, 0.25),
      20.0 is 80.0 * 0.25]).
step(sample(iodine_sample, initial_activity_bq, 80.0), fact(1), [], []).
step(remaining_fraction(iodine_sample, 0.25),
     rule(6),
     ['Sample' = iodine_sample, 'Fraction' = 0.25, 'Count' = 2.0],
     [half_lives(iodine_sample, 2.0), 0.25 is 0.5 ** 2.0]).
step(0.25 is 0.5 ** 2.0, builtin, [], []).
step(20.0 is 80.0 * 0.25, builtin, [], []).
step(decayedActivity_Bq(iodine_sample, 60.0),
     rule(12),
     ['Sample' = iodine_sample, 'Decayed' = 60.0],
     [decayed_activity(iodine_sample, 60.0)]).
step(decayed_activity(iodine_sample, 60.0),
     rule(8),
     ['Sample' = iodine_sample, 'Decayed' = 60.0, 'Initial' = 80.0, 'Remaining' = 20.0],
     [sample(iodine_sample, initial_activity_bq, 80.0),
      remaining_activity(iodine_sample, 20.0),
      60.0 is 80.0 - 20.0]).
step(60.0 is 80.0 - 20.0, builtin, [], []).
step(status(iodine_sample, low_activity),
     rule(13),
     ['Sample' = iodine_sample],
     [low_activity(iodine_sample)]).
step(low_activity(iodine_sample),
     rule(9),
     ['Sample' = iodine_sample, 'Remaining' = 20.0, 'Limit' = 25.0],
     [remaining_activity(iodine_sample, 20.0),
      threshold(iodine_sample, low_activity_bq, 25.0),
      20.0 < 25.0]).
step(threshold(iodine_sample, low_activity_bq, 25.0), fact(4), [], []).
step(20.0 < 25.0, builtin, [], []).
step(reason(iodine_sample, "two half-lives leave one quarter of the initial activity"),
     rule(14),
     ['Sample' = iodine_sample],
     [low_activity(iodine_sample)]).
