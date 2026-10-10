# Web names

## Can web identifiers be ordinary Prolog atoms?

On the web, people, organizations, and projects are named by IRIs, global
identifiers such as `https://schema.org/name`. This example stores a tiny
knowledge graph whose names are IRIs written as quoted atoms, and joins facts
across it with plain Prolog rules.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=web-names) ·
[Source](../web-names.pl)

---

# The question

Which organizations is a person affiliated with, counting parent
organizations? Who is the contact person for a project, and what is their
email?

Because IRIs are globally unique, two facts that use the same IRI are about the
same thing, wherever they came from. That makes joining data from different
sources safe.

---

# The facts

```prolog
triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>').
triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>').
triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>').
```

Each fact is a triple, subject–predicate–object, the shape of RDF data. The
angle-bracketed IRIs are just quoted atoms; no prefix declarations are needed.

---

# The rules

```prolog
parent_organization(Unit, Org) :-
    triple(Unit, '<https://schema.org/parentOrganization>', Org).
parent_organization(Unit, Org) :-
    triple(Unit, '<https://schema.org/parentOrganization>', Mid),
    parent_organization(Mid, Org).

affiliated_with(Person, Org) :-
    triple(Person, '<https://schema.org/affiliation>', Unit),
    parent_organization(Unit, Org).
```

Affiliation is inherited up the organization tree, following
`parentOrganization` links recursively. A second `affiliated_with/2` clause
covers the direct affiliation.

---

# The answer

```sh
eyeprolog examples/web-names.pl
```

```text
affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>').
affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>').
project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com").
```

The person is affiliated with IDLab directly and with Ghent University through
IDLab. The project contact comes from joining the maintainer triple with the
email triple on the same IRI.

---

# The reason

```text
step(affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>'),
     rule(11),
     ['Person' = '<https://data.ugent.be/id/josd>',
      'Org' = '<https://data.ugent.be/id/ugent>',
      'Unit' = '<https://data.ugent.be/id/idlab>'],
```

The UGent affiliation holds by the inherited-affiliation rule (clause 11) with
IDLab as the intermediate unit. The step goes on to cite the affiliation
triple and the parent-organization link.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C4', coverage, ok, 9).
condition('C7', relevance, ok, 11).
verdict(checked).
```

All 8 steps are rule or fact steps, and the checker replays each one against
the triples and rules. No built-in and no boundary is involved.

---

# Try it

- Add a parent organization above UGent and predict the new affiliation.
- Add a second project with the same maintainer and ask for its contact.
- Add a `triple/3` for the person's name and include it in `project_contact`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
