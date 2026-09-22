feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))).
why(
  feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))),
  step(
    feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))),
    rule("clpb-feature-model.pl", clause(2)),
    ['Cloud' = 0, 'Edge' = 1, 'Audit' = 1, 'Encryption' = 1],
    [
      step(
        feature_constraints(0, 1, 1, 1),
        rule("clpb-feature-model.pl", clause(1)),
        ['Cloud' = 0, 'Edge' = 1, 'Audit' = 1, 'Encryption' = 1],
        [
          step(sat(*(*(#(0, 1), =<(1, 1)), =<(1, 1))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([0, 1, 1, 1]), library(labeling, 1), [], [])
    ]
  )
).

feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))).
why(
  feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))),
  step(
    feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))),
    rule("clpb-feature-model.pl", clause(2)),
    ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 0],
    [
      step(
        feature_constraints(1, 0, 0, 0),
        rule("clpb-feature-model.pl", clause(1)),
        ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 0],
        [
          step(sat(*(*(#(1, 0), =<(0, 0)), =<(0, 0))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([1, 0, 0, 0]), library(labeling, 1), [], [])
    ]
  )
).

feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))).
why(
  feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))),
  step(
    feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))),
    rule("clpb-feature-model.pl", clause(2)),
    ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 1],
    [
      step(
        feature_constraints(1, 0, 0, 1),
        rule("clpb-feature-model.pl", clause(1)),
        ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 1],
        [
          step(sat(*(*(#(1, 0), =<(0, 1)), =<(0, 0))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([1, 0, 0, 1]), library(labeling, 1), [], [])
    ]
  )
).

feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))).
why(
  feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))),
  step(
    feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))),
    rule("clpb-feature-model.pl", clause(2)),
    ['Cloud' = 1, 'Edge' = 0, 'Audit' = 1, 'Encryption' = 1],
    [
      step(
        feature_constraints(1, 0, 1, 1),
        rule("clpb-feature-model.pl", clause(1)),
        ['Cloud' = 1, 'Edge' = 0, 'Audit' = 1, 'Encryption' = 1],
        [
          step(sat(*(*(#(1, 0), =<(1, 1)), =<(0, 1))), library(sat, 1), [], [])
        ]
      ),
      step(labeling([1, 0, 1, 1]), library(labeling, 1), [], [])
    ]
  )
).

feature_plan_count(4).
why(
  feature_plan_count(4),
  no_proof
).

