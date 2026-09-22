affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>').
why(
  affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>'),
  step(
    affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>'),
    rule("web-names.pl", clause(10)),
    ['Person' = '<https://data.ugent.be/id/josd>', 'Org' = '<https://data.ugent.be/id/idlab>'],
    [
      step(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>'), fact("web-names.pl", clause(3)), [], [])
    ]
  )
).

affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>').
why(
  affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>'),
  step(
    affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>'),
    rule("web-names.pl", clause(11)),
    ['Person' = '<https://data.ugent.be/id/josd>', 'Org' = '<https://data.ugent.be/id/ugent>', 'Unit' = '<https://data.ugent.be/id/idlab>'],
    [
      step(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>'), fact("web-names.pl", clause(3)), [], []),
      step(
        parent_organization('<https://data.ugent.be/id/idlab>', '<https://data.ugent.be/id/ugent>'),
        rule("web-names.pl", clause(8)),
        ['Unit' = '<https://data.ugent.be/id/idlab>', 'Org' = '<https://data.ugent.be/id/ugent>'],
        [
          step(triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>'), fact("web-names.pl", clause(4)), [], [])
        ]
      )
    ]
  )
).

project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com").
why(
  project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com"),
  step(
    project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com"),
    rule("web-names.pl", clause(12)),
    ['Project' = '<https://github.com/eyereasoner/eyeprolog>', 'Person' = '<https://data.ugent.be/id/josd>', 'Email' = "josderoo@gmail.com"],
    [
      step(triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>'), fact("web-names.pl", clause(7)), [], []),
      step(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/email>', "josderoo@gmail.com"), fact("web-names.pl", clause(2)), [], [])
    ]
  )
).

