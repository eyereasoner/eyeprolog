# Example data and roundtrip support

This directory contains source and materialized data that support runnable examples without adding extra root-level `.pl` programs to the example test discovery.

## Symbiotic Knowledge Graphs

The heatwave-response example uses [`rdf-prolog-interchange`](https://github.com/eyereasoner/rdf-prolog-interchange) as its RDF boundary:

```text
symbiotic-knowledge-graph-input.nq
    -> rdf-to-prolog + symbiotic-knowledge-graph-rules.pl
    -> ../symbiotic-knowledge-graph.pl
    -> EyeProlog result_rdf/4
    -> symbiotic-knowledge-graph-output.pl
    -> prolog-to-rdf
    -> symbiotic-knowledge-graph-output.nq
```

The input uses named graphs for source boundaries and RDF 1.2 triple terms for AI-proposed statements. A proposed triple is therefore metadata until governance rules accept it; it does not become an operational assertion merely because an AI produced it.

See [the wide-audience deck](../deck/symbiotic-knowledge-graphs.md) for the scenario and architecture.

## Additional decision and evidence roundtrips

Five further examples use the same explicit boundary: source RDF is converted to `rdf/4` facts, portable rules are appended for EyeProlog, checked conclusions are emitted as Prolog, and ground result facts are converted back to RDF.

| Scenario | Source and rules | Materialized result | Companion |
| --- | --- | --- | --- |
| Cross-organization data sharing | [`cross-organization-data-sharing-input.nq`](cross-organization-data-sharing-input.nq) · [`cross-organization-data-sharing-rules.pl`](cross-organization-data-sharing-rules.pl) | [`cross-organization-data-sharing-output.nq`](cross-organization-data-sharing-output.nq) | [deck](../deck/cross-organization-data-sharing.md) |
| Explainable EV-depot configuration | [`explainable-ev-depot-configuration-input.nq`](explainable-ev-depot-configuration-input.nq) · [`explainable-ev-depot-configuration-rules.pl`](explainable-ev-depot-configuration-rules.pl) | [`explainable-ev-depot-configuration-output.nq`](explainable-ev-depot-configuration-output.nq) | [deck](../deck/explainable-ev-depot-configuration.md) |
| Operational incident response | [`operational-incident-response-input.nq`](operational-incident-response-input.nq) · [`operational-incident-response-rules.pl`](operational-incident-response-rules.pl) | [`operational-incident-response-output.nq`](operational-incident-response-output.nq) | [deck](../deck/operational-incident-response.md) |
| SBOM vulnerability response | [`sbom-vulnerability-response-input.nq`](sbom-vulnerability-response-input.nq) · [`sbom-vulnerability-response-rules.pl`](sbom-vulnerability-response-rules.pl) | [`sbom-vulnerability-response-output.nq`](sbom-vulnerability-response-output.nq) | [deck](../deck/sbom-vulnerability-response.md) |
| Scientific evidence graph | [`scientific-evidence-graph-input.nq`](scientific-evidence-graph-input.nq) · [`scientific-evidence-graph-rules.pl`](scientific-evidence-graph-rules.pl) | [`scientific-evidence-graph-output.nq`](scientific-evidence-graph-output.nq) | [deck](../deck/scientific-evidence-graph.md) |

Each scenario also has a generated runnable program one directory up and a checked stdout file in `../output/`. The corresponding deck contains the exact reproduction commands for the RDF roundtrip.

