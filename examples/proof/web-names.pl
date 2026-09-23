affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>').
affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>').
project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com").

clause(2,
       triple('<https://data.ugent.be/id/josd>', '<https://schema.org/email>', "josderoo@gmail.com"),
       true).
clause(3,
       triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>'),
       true).
clause(4,
       triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>'),
       true).
clause(7,
       triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>'),
       true).
clause(8,
       parent_organization(var('Unit'), var('Org')),
       triple(var('Unit'), '<https://schema.org/parentOrganization>', var('Org'))).
clause(10,
       affiliated_with(var('Person'), var('Org')),
       triple(var('Person'), '<https://schema.org/affiliation>', var('Org'))).
clause(11,
       affiliated_with(var('Person'), var('Org')),
       (triple(var('Person'), '<https://schema.org/affiliation>', var('Unit')),
        parent_organization(var('Unit'), var('Org')))).
clause(12,
       project_contact(var('Project'), var('Person'), var('Email')),
       (triple(var('Project'), '<https://schema.org/maintainer>', var('Person')),
        triple(var('Person'), '<https://schema.org/email>', var('Email')))).

step(affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>'),
     rule(10),
     ['Person' = '<https://data.ugent.be/id/josd>', 'Org' = '<https://data.ugent.be/id/idlab>'],
     [triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>')]).
step(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>'),
     fact(3),
     [],
     []).
step(affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>'),
     rule(11),
     ['Person' = '<https://data.ugent.be/id/josd>',
      'Org' = '<https://data.ugent.be/id/ugent>',
      'Unit' = '<https://data.ugent.be/id/idlab>'],
     [triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>'),
      parent_organization('<https://data.ugent.be/id/idlab>', '<https://data.ugent.be/id/ugent>')]).
step(parent_organization('<https://data.ugent.be/id/idlab>', '<https://data.ugent.be/id/ugent>'),
     rule(8),
     ['Unit' = '<https://data.ugent.be/id/idlab>', 'Org' = '<https://data.ugent.be/id/ugent>'],
     [triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>')]).
step(triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>'),
     fact(4),
     [],
     []).
step(project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com"),
     rule(12),
     ['Project' = '<https://github.com/eyereasoner/eyeprolog>',
      'Person' = '<https://data.ugent.be/id/josd>',
      'Email' = "josderoo@gmail.com"],
     [triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>'),
      triple('<https://data.ugent.be/id/josd>', '<https://schema.org/email>', "josderoo@gmail.com")]).
step(triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>'),
     fact(7),
     [],
     []).
step(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/email>', "josderoo@gmail.com"),
     fact(2),
     [],
     []).
