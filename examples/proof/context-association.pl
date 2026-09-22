dataGraph(association, skolem_g0).
why(
  dataGraph(association, skolem_g0),
  step(
    dataGraph(association, skolem_g0),
    rule("context-association.pl", clause(8)),
    [],
    [
      step(
        context_statement(skolem_g0, bob, foaf_name, "Bob"),
        rule("context-association.pl", clause(7)),
        ['Contextname' = skolem_g0, 'Subject' = bob, 'Predicate' = foaf_name, 'Object' = "Bob", 'Context' = foaf_name(bob, "Bob"), 'Statement' = foaf_name(bob, "Bob")],
        [
          step(log_nameOf(skolem_g0, foaf_name(bob, "Bob")), fact("context-association.pl", clause(1)), [], []),
          step(
            context_member(foaf_name(bob, "Bob"), foaf_name(bob, "Bob")),
            rule("context-association.pl", clause(6)),
            ['Member' = foaf_name(bob, "Bob")],
            [
              step(\=(foaf_name(bob, "Bob"), (_left, _right)), builtin(\=, 2), [], [])
            ]
          ),
          step('=..'(foaf_name(bob, "Bob"), [foaf_name, bob, "Bob"]), builtin('=..', 2), [], [])
        ]
      )
    ]
  )
).

signatureGraph(association, skolem_g1).
why(
  signatureGraph(association, skolem_g1),
  step(
    signatureGraph(association, skolem_g1),
    rule("context-association.pl", clause(9)),
    [],
    [
      step(
        context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature),
        rule("context-association.pl", clause(7)),
        ['Contextname' = skolem_g1, 'Subject' = skolem_g0, 'Predicate' = sec_proof, 'Object' = dataSignature, 'Context' = (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), 'Statement' = sec_proof(skolem_g0, dataSignature)],
        [
          step(log_nameOf(skolem_g1, (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))), fact("context-association.pl", clause(2)), [], []),
          step(
            context_member((sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), sec_proof(skolem_g0, dataSignature)),
            rule("context-association.pl", clause(4)),
            ['Left' = sec_proof(skolem_g0, dataSignature), '_right' = (type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), 'Member' = sec_proof(skolem_g0, dataSignature)],
            [
              step(
                context_member(sec_proof(skolem_g0, dataSignature), sec_proof(skolem_g0, dataSignature)),
                rule("context-association.pl", clause(6)),
                ['Member' = sec_proof(skolem_g0, dataSignature)],
                [
                  step(\=(sec_proof(skolem_g0, dataSignature), (_left, _right)), builtin(\=, 2), [], [])
                ]
              )
            ]
          ),
          step('=..'(sec_proof(skolem_g0, dataSignature), [sec_proof, skolem_g0, dataSignature]), builtin('=..', 2), [], [])
        ]
      )
    ]
  )
).

metadataGraph(association, g3).
why(
  metadataGraph(association, g3),
  step(
    metadataGraph(association, g3),
    rule("context-association.pl", clause(10)),
    [],
    [
      step(
        context_statement(g3, skolem_g1, sec_proof, signature2),
        rule("context-association.pl", clause(7)),
        ['Contextname' = g3, 'Subject' = skolem_g1, 'Predicate' = sec_proof, 'Object' = signature2, 'Context' = (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), 'Statement' = sec_proof(skolem_g1, signature2)],
        [
          step(log_nameOf(g3, (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))), fact("context-association.pl", clause(3)), [], []),
          step(
            context_member((sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), sec_proof(skolem_g1, signature2)),
            rule("context-association.pl", clause(4)),
            ['Left' = sec_proof(skolem_g1, signature2), '_right' = (type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), 'Member' = sec_proof(skolem_g1, signature2)],
            [
              step(
                context_member(sec_proof(skolem_g1, signature2), sec_proof(skolem_g1, signature2)),
                rule("context-association.pl", clause(6)),
                ['Member' = sec_proof(skolem_g1, signature2)],
                [
                  step(\=(sec_proof(skolem_g1, signature2), (_left, _right)), builtin(\=, 2), [], [])
                ]
              )
            ]
          ),
          step('=..'(sec_proof(skolem_g1, signature2), [sec_proof, skolem_g1, signature2]), builtin('=..', 2), [], [])
        ]
      )
    ]
  )
).

