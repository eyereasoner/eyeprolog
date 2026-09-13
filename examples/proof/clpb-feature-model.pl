feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))).
why(
  feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))),
  proof(
    goal(feature_plan(features(cloud(0), edge(1), audit(1), encryption(1)))),
    by(rule("clpb-feature-model.pl", clause(2))),
    bindings([binding("Cloud", 0), binding("Edge", 1), binding("Audit", 1), binding("Encryption", 1)]),
    uses([
      proof(
        goal(feature_constraints(0, 1, 1, 1)),
        by(rule("clpb-feature-model.pl", clause(1))),
        bindings([binding("Cloud", 0), binding("Edge", 1), binding("Audit", 1), binding("Encryption", 1)]),
        uses([
          proof(
            goal(sat(*(*(#(0, 1), =<(1, 1)), =<(1, 1)))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([0, 1, 1, 1])),
        by(library(labeling, 1))
      )
    ])
  )
).

feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))).
why(
  feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))),
  proof(
    goal(feature_plan(features(cloud(1), edge(0), audit(0), encryption(0)))),
    by(rule("clpb-feature-model.pl", clause(2))),
    bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 0), binding("Encryption", 0)]),
    uses([
      proof(
        goal(feature_constraints(1, 0, 0, 0)),
        by(rule("clpb-feature-model.pl", clause(1))),
        bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 0), binding("Encryption", 0)]),
        uses([
          proof(
            goal(sat(*(*(#(1, 0), =<(0, 0)), =<(0, 0)))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([1, 0, 0, 0])),
        by(library(labeling, 1))
      )
    ])
  )
).

feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))).
why(
  feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))),
  proof(
    goal(feature_plan(features(cloud(1), edge(0), audit(0), encryption(1)))),
    by(rule("clpb-feature-model.pl", clause(2))),
    bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 0), binding("Encryption", 1)]),
    uses([
      proof(
        goal(feature_constraints(1, 0, 0, 1)),
        by(rule("clpb-feature-model.pl", clause(1))),
        bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 0), binding("Encryption", 1)]),
        uses([
          proof(
            goal(sat(*(*(#(1, 0), =<(0, 1)), =<(0, 0)))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([1, 0, 0, 1])),
        by(library(labeling, 1))
      )
    ])
  )
).

feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))).
why(
  feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))),
  proof(
    goal(feature_plan(features(cloud(1), edge(0), audit(1), encryption(1)))),
    by(rule("clpb-feature-model.pl", clause(2))),
    bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 1), binding("Encryption", 1)]),
    uses([
      proof(
        goal(feature_constraints(1, 0, 1, 1)),
        by(rule("clpb-feature-model.pl", clause(1))),
        bindings([binding("Cloud", 1), binding("Edge", 0), binding("Audit", 1), binding("Encryption", 1)]),
        uses([
          proof(
            goal(sat(*(*(#(1, 0), =<(1, 1)), =<(0, 1)))),
            by(library(sat, 1))
          )
        ])
      ),
      proof(
        goal(labeling([1, 0, 1, 1])),
        by(library(labeling, 1))
      )
    ])
  )
).

feature_plan_count(4).
why(
  feature_plan_count(4),
  no_proof
).

