result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph).
why(
  result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph),
  step(
    result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph),
    rule("rdf12-directional-language.pl", clause(3)),
    ['S' = iri('https://example.org/welcome'), 'Label' = literal('مرحبا', lang(ar, rtl)), 'G' = default_graph],
    [
      step(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph), fact("rdf12-directional-language.pl", clause(1)), [], [])
    ]
  )
).

result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph).
why(
  result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph),
  step(
    result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph),
    rule("rdf12-directional-language.pl", clause(3)),
    ['S' = iri('https://example.org/welcome'), 'Label' = literal('Welcome', lang(en, ltr)), 'G' = default_graph],
    [
      step(rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang(en, ltr)), default_graph), fact("rdf12-directional-language.pl", clause(2)), [], [])
    ]
  )
).

