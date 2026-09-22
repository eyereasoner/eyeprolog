% Prolog result format 4
query(1, answer(_0), ['__anon0' = _0]).
result(1, complete, 1).
answer(1,
       ['__anon0' = 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD']).
query(2, reason(_0), ['__anon0' = _0]).
result(2, complete, 1).
answer(2,
       ['__anon0' = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).']).
query(3, check(_0, _1, _2), ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2]).
result(3, complete, 5).
answer(3,
       ['__anon0' = 1,
        '__anon1' = 'Functional Correctness (All minterms covered)',
        '__anon2' = true]).
answer(3,
       ['__anon0' = 2,
        '__anon1' = 'Safety Check (No false positives outside DCs)',
        '__anon2' = true]).
answer(3, ['__anon0' = 3, '__anon1' = 'Minimality (Cardinality) Proof', '__anon2' = true]).
answer(3,
       ['__anon0' = 4,
        '__anon1' = 'Canonical Tie-Breaking (Lexicographical First)',
        '__anon2' = true]).
answer(3,
       ['__anon0' = 5,
        '__anon1' = 'Consistency (Solution is subset of Primes)',
        '__anon2' = true]).
