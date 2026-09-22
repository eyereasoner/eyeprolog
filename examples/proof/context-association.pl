% Prolog result format 4
query(1, log_nameOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, dataGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = association, 'X1' = skolem_g0]).
why(2, ['X0' = association, 'X1' = skolem_g0], [dataGraph(association, skolem_g0)]).
query(3, signatureGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = association, 'X1' = skolem_g1]).
why(3, ['X0' = association, 'X1' = skolem_g1], [signatureGraph(association, skolem_g1)]).
query(4, metadataGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = association, 'X1' = g3]).
why(4, ['X0' = association, 'X1' = g3], [metadataGraph(association, g3)]).

clause(1, log_nameOf(skolem_g0, foaf_name(bob, "Bob")), true).
clause(2,
       log_nameOf(skolem_g1, (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))),
       true).
clause(3,
       log_nameOf(g3, (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))),
       true).
clause(4,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(6,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(7,
       context_statement(var('Contextname'), var('Subject'), var('Predicate'), var('Object')),
       (log_nameOf(var('Contextname'), var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('Predicate'), var('Subject'), var('Object')])).
clause(8,
       dataGraph(association, skolem_g0),
       context_statement(skolem_g0, bob, foaf_name, "Bob")).
clause(9,
       signatureGraph(association, skolem_g1),
       context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature)).
clause(10,
       metadataGraph(association, g3),
       context_statement(g3, skolem_g1, sec_proof, signature2)).

step(dataGraph(association, skolem_g0),
     rule(8),
     [],
     [context_statement(skolem_g0, bob, foaf_name, "Bob")]).
step(context_statement(skolem_g0, bob, foaf_name, "Bob"),
     rule(7),
     ['Contextname' = skolem_g0,
      'Subject' = bob,
      'Predicate' = foaf_name,
      'Object' = "Bob",
      'Context' = foaf_name(bob, "Bob"),
      'Statement' = foaf_name(bob, "Bob")],
     [log_nameOf(skolem_g0, foaf_name(bob, "Bob")),
      context_member(foaf_name(bob, "Bob"), foaf_name(bob, "Bob")),
      foaf_name(bob, "Bob") =.. [foaf_name, bob, "Bob"]]).
step(log_nameOf(skolem_g0, foaf_name(bob, "Bob")), fact(1), [], []).
step(context_member(foaf_name(bob, "Bob"), foaf_name(bob, "Bob")),
     rule(6),
     ['Member' = foaf_name(bob, "Bob")],
     [foaf_name(bob, "Bob") \= (_left, _right)]).
step(foaf_name(bob, "Bob") \= (_left, _right), builtin, [], []).
step(foaf_name(bob, "Bob") =.. [foaf_name, bob, "Bob"], builtin, [], []).
step(signatureGraph(association, skolem_g1),
     rule(9),
     [],
     [context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature)]).
step(context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature),
     rule(7),
     ['Contextname' = skolem_g1,
      'Subject' = skolem_g0,
      'Predicate' = sec_proof,
      'Object' = dataSignature,
      'Context' = (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")),
      'Statement' = sec_proof(skolem_g0, dataSignature)],
     [log_nameOf(skolem_g1, (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))),
      context_member((sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), sec_proof(skolem_g0, dataSignature)),
      sec_proof(skolem_g0, dataSignature) =.. [sec_proof, skolem_g0, dataSignature]]).
step(log_nameOf(skolem_g1, (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))),
     fact(2),
     [],
     []).
step(context_member((sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), sec_proof(skolem_g0, dataSignature)),
     rule(4),
     ['Left' = sec_proof(skolem_g0, dataSignature),
      'Member' = sec_proof(skolem_g0, dataSignature)],
     [context_member(sec_proof(skolem_g0, dataSignature), sec_proof(skolem_g0, dataSignature))]).
step(context_member(sec_proof(skolem_g0, dataSignature), sec_proof(skolem_g0, dataSignature)),
     rule(6),
     ['Member' = sec_proof(skolem_g0, dataSignature)],
     [sec_proof(skolem_g0, dataSignature) \= (_left, _right)]).
step(sec_proof(skolem_g0, dataSignature) \= (_left, _right), builtin, [], []).
step(sec_proof(skolem_g0, dataSignature) =.. [sec_proof, skolem_g0, dataSignature],
     builtin,
     [],
     []).
step(metadataGraph(association, g3),
     rule(10),
     [],
     [context_statement(g3, skolem_g1, sec_proof, signature2)]).
step(context_statement(g3, skolem_g1, sec_proof, signature2),
     rule(7),
     ['Contextname' = g3,
      'Subject' = skolem_g1,
      'Predicate' = sec_proof,
      'Object' = signature2,
      'Context' = (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")),
      'Statement' = sec_proof(skolem_g1, signature2)],
     [log_nameOf(g3, (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))),
      context_member((sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), sec_proof(skolem_g1, signature2)),
      sec_proof(skolem_g1, signature2) =.. [sec_proof, skolem_g1, signature2]]).
step(log_nameOf(g3, (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))),
     fact(3),
     [],
     []).
step(context_member((sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), sec_proof(skolem_g1, signature2)),
     rule(4),
     ['Left' = sec_proof(skolem_g1, signature2), 'Member' = sec_proof(skolem_g1, signature2)],
     [context_member(sec_proof(skolem_g1, signature2), sec_proof(skolem_g1, signature2))]).
step(context_member(sec_proof(skolem_g1, signature2), sec_proof(skolem_g1, signature2)),
     rule(6),
     ['Member' = sec_proof(skolem_g1, signature2)],
     [sec_proof(skolem_g1, signature2) \= (_left, _right)]).
step(sec_proof(skolem_g1, signature2) \= (_left, _right), builtin, [], []).
step(sec_proof(skolem_g1, signature2) =.. [sec_proof, skolem_g1, signature2], builtin, [], []).
