syndrome(packet1, 5).
errorBit(packet1, 5).
correctedCodeword(packet1, [1, 0, 1, 1, 0, 1, 0]).
decodedPayload(packet1, [1, 0, 1, 0]).
status(packet1, single_bit_corrected).
reason(packet1, "Hamming syndrome identifies the flipped bit position").

clause(1, received_bit(packet1, 1, 1), true).
clause(2, received_bit(packet1, 2, 0), true).
clause(3, received_bit(packet1, 3, 1), true).
clause(4, received_bit(packet1, 4, 1), true).
clause(5, received_bit(packet1, 5, 1), true).
clause(6, received_bit(packet1, 6, 1), true).
clause(7, received_bit(packet1, 7, 0), true).
clause(9, flip(1, 0), true).
clause(10,
       parity4(var('A'), var('B'), var('C'), var('D'), var('Parity')),
       (var('Ab') is var('A') + var('B'),
        var('Abc') is var('Ab') + var('C'),
        var('Sum') is var('Abc') + var('D'),
        var('Parity') is var('Sum') mod 2)).
clause(11,
       syndrome_bit1(var('Code'), var('S1')),
       (received_bit(var('Code'), 1, var('B1')),
        received_bit(var('Code'), 3, var('B3')),
        received_bit(var('Code'), 5, var('B5')),
        received_bit(var('Code'), 7, var('B7')),
        parity4(var('B1'), var('B3'), var('B5'), var('B7'), var('S1')))).
clause(12,
       syndrome_bit2(var('Code'), var('S2')),
       (received_bit(var('Code'), 2, var('B2')),
        received_bit(var('Code'), 3, var('B3')),
        received_bit(var('Code'), 6, var('B6')),
        received_bit(var('Code'), 7, var('B7')),
        parity4(var('B2'), var('B3'), var('B6'), var('B7'), var('S2')))).
clause(13,
       syndrome_bit4(var('Code'), var('S4')),
       (received_bit(var('Code'), 4, var('B4')),
        received_bit(var('Code'), 5, var('B5')),
        received_bit(var('Code'), 6, var('B6')),
        received_bit(var('Code'), 7, var('B7')),
        parity4(var('B4'), var('B5'), var('B6'), var('B7'), var('S4')))).
clause(14,
       syndrome(var('Code'), var('Syndrome')),
       (syndrome_bit1(var('Code'), var('S1')),
        syndrome_bit2(var('Code'), var('S2')),
        syndrome_bit4(var('Code'), var('S4')),
        var('Weighteds2') is var('S2') * 2,
        var('Weighteds4') is var('S4') * 4,
        var('Partial') is var('S1') + var('Weighteds2'),
        var('Syndrome') is var('Partial') + var('Weighteds4'))).
clause(15,
       corrected_bit(var('Code'), var('Position'), var('Corrected')),
       (syndrome(var('Code'), var('Position')),
        received_bit(var('Code'), var('Position'), var('Bit')),
        flip(var('Bit'), var('Corrected')))).
clause(16,
       corrected_bit(var('Code'), var('Position'), var('Bit')),
       (syndrome(var('Code'), var('Errorposition')),
        var('Position') \= var('Errorposition'),
        received_bit(var('Code'), var('Position'), var('Bit')))).
clause(17,
       corrected_codeword(var('Code'), [var('B1'), var('B2'), var('B3'), var('B4'), var('B5'), var('B6'), var('B7')]),
       (corrected_bit(var('Code'), 1, var('B1')),
        corrected_bit(var('Code'), 2, var('B2')),
        corrected_bit(var('Code'), 3, var('B3')),
        corrected_bit(var('Code'), 4, var('B4')),
        corrected_bit(var('Code'), 5, var('B5')),
        corrected_bit(var('Code'), 6, var('B6')),
        corrected_bit(var('Code'), 7, var('B7')))).
clause(18,
       decoded_payload(var('Code'), [var('D1'), var('D2'), var('D3'), var('D4')]),
       (corrected_bit(var('Code'), 3, var('D1')),
        corrected_bit(var('Code'), 5, var('D2')),
        corrected_bit(var('Code'), 6, var('D3')),
        corrected_bit(var('Code'), 7, var('D4')))).
clause(19,
       errorBit(var('Code'), var('Position')),
       (syndrome(var('Code'), var('Position')), var('Position') > 0)).
clause(20,
       correctedCodeword(var('Code'), var('Codeword')),
       corrected_codeword(var('Code'), var('Codeword'))).
clause(21,
       decodedPayload(var('Code'), var('Payload')),
       decoded_payload(var('Code'), var('Payload'))).
clause(22,
       status(var('Code'), single_bit_corrected),
       (syndrome(var('Code'), var('Position')), var('Position') > 0)).
clause(23,
       reason(var('Code'), "Hamming syndrome identifies the flipped bit position"),
       (syndrome(var('Code'), var('Position')), var('Position') > 0)).

step(syndrome(packet1, 5),
     rule(14),
     ['Code' = packet1,
      'Syndrome' = 5,
      'S1' = 1,
      'S2' = 0,
      'S4' = 1,
      'Weighteds2' = 0,
      'Weighteds4' = 4,
      'Partial' = 1],
     [syndrome_bit1(packet1, 1),
      syndrome_bit2(packet1, 0),
      syndrome_bit4(packet1, 1),
      0 is 0 * 2,
      4 is 1 * 4,
      1 is 1 + 0,
      5 is 1 + 4]).
step(syndrome_bit1(packet1, 1),
     rule(11),
     ['Code' = packet1, 'S1' = 1, 'B1' = 1, 'B3' = 1, 'B5' = 1, 'B7' = 0],
     [received_bit(packet1, 1, 1),
      received_bit(packet1, 3, 1),
      received_bit(packet1, 5, 1),
      received_bit(packet1, 7, 0),
      parity4(1, 1, 1, 0, 1)]).
step(received_bit(packet1, 1, 1), fact(1), [], []).
step(received_bit(packet1, 3, 1), fact(3), [], []).
step(received_bit(packet1, 5, 1), fact(5), [], []).
step(received_bit(packet1, 7, 0), fact(7), [], []).
step(parity4(1, 1, 1, 0, 1),
     rule(10),
     ['A' = 1, 'B' = 1, 'C' = 1, 'D' = 0, 'Parity' = 1, 'Ab' = 2, 'Abc' = 3, 'Sum' = 3],
     [2 is 1 + 1, 3 is 2 + 1, 3 is 3 + 0, 1 is 3 mod 2]).
step(2 is 1 + 1, builtin, [], []).
step(3 is 2 + 1, builtin, [], []).
step(3 is 3 + 0, builtin, [], []).
step(1 is 3 mod 2, builtin, [], []).
step(syndrome_bit2(packet1, 0),
     rule(12),
     ['Code' = packet1, 'S2' = 0, 'B2' = 0, 'B3' = 1, 'B6' = 1, 'B7' = 0],
     [received_bit(packet1, 2, 0),
      received_bit(packet1, 3, 1),
      received_bit(packet1, 6, 1),
      received_bit(packet1, 7, 0),
      parity4(0, 1, 1, 0, 0)]).
step(received_bit(packet1, 2, 0), fact(2), [], []).
step(received_bit(packet1, 6, 1), fact(6), [], []).
step(parity4(0, 1, 1, 0, 0),
     rule(10),
     ['A' = 0, 'B' = 1, 'C' = 1, 'D' = 0, 'Parity' = 0, 'Ab' = 1, 'Abc' = 2, 'Sum' = 2],
     [1 is 0 + 1, 2 is 1 + 1, 2 is 2 + 0, 0 is 2 mod 2]).
step(1 is 0 + 1, builtin, [], []).
step(2 is 2 + 0, builtin, [], []).
step(0 is 2 mod 2, builtin, [], []).
step(syndrome_bit4(packet1, 1),
     rule(13),
     ['Code' = packet1, 'S4' = 1, 'B4' = 1, 'B5' = 1, 'B6' = 1, 'B7' = 0],
     [received_bit(packet1, 4, 1),
      received_bit(packet1, 5, 1),
      received_bit(packet1, 6, 1),
      received_bit(packet1, 7, 0),
      parity4(1, 1, 1, 0, 1)]).
step(received_bit(packet1, 4, 1), fact(4), [], []).
step(0 is 0 * 2, builtin, [], []).
step(4 is 1 * 4, builtin, [], []).
step(1 is 1 + 0, builtin, [], []).
step(5 is 1 + 4, builtin, [], []).
step(errorBit(packet1, 5),
     rule(19),
     ['Code' = packet1, 'Position' = 5],
     [syndrome(packet1, 5), 5 > 0]).
step(5 > 0, builtin, [], []).
step(correctedCodeword(packet1, [1, 0, 1, 1, 0, 1, 0]),
     rule(20),
     ['Code' = packet1, 'Codeword' = [1, 0, 1, 1, 0, 1, 0]],
     [corrected_codeword(packet1, [1, 0, 1, 1, 0, 1, 0])]).
step(corrected_codeword(packet1, [1, 0, 1, 1, 0, 1, 0]),
     rule(17),
     ['Code' = packet1, 'B1' = 1, 'B2' = 0, 'B3' = 1, 'B4' = 1, 'B5' = 0, 'B6' = 1, 'B7' = 0],
     [corrected_bit(packet1, 1, 1),
      corrected_bit(packet1, 2, 0),
      corrected_bit(packet1, 3, 1),
      corrected_bit(packet1, 4, 1),
      corrected_bit(packet1, 5, 0),
      corrected_bit(packet1, 6, 1),
      corrected_bit(packet1, 7, 0)]).
step(corrected_bit(packet1, 1, 1),
     rule(16),
     ['Code' = packet1, 'Position' = 1, 'Bit' = 1, 'Errorposition' = 5],
     [syndrome(packet1, 5), 1 \= 5, received_bit(packet1, 1, 1)]).
step(1 \= 5, builtin, [], []).
step(corrected_bit(packet1, 2, 0),
     rule(16),
     ['Code' = packet1, 'Position' = 2, 'Bit' = 0, 'Errorposition' = 5],
     [syndrome(packet1, 5), 2 \= 5, received_bit(packet1, 2, 0)]).
step(2 \= 5, builtin, [], []).
step(corrected_bit(packet1, 3, 1),
     rule(16),
     ['Code' = packet1, 'Position' = 3, 'Bit' = 1, 'Errorposition' = 5],
     [syndrome(packet1, 5), 3 \= 5, received_bit(packet1, 3, 1)]).
step(3 \= 5, builtin, [], []).
step(corrected_bit(packet1, 4, 1),
     rule(16),
     ['Code' = packet1, 'Position' = 4, 'Bit' = 1, 'Errorposition' = 5],
     [syndrome(packet1, 5), 4 \= 5, received_bit(packet1, 4, 1)]).
step(4 \= 5, builtin, [], []).
step(corrected_bit(packet1, 5, 0),
     rule(15),
     ['Code' = packet1, 'Position' = 5, 'Corrected' = 0, 'Bit' = 1],
     [syndrome(packet1, 5), received_bit(packet1, 5, 1), flip(1, 0)]).
step(flip(1, 0), fact(9), [], []).
step(corrected_bit(packet1, 6, 1),
     rule(16),
     ['Code' = packet1, 'Position' = 6, 'Bit' = 1, 'Errorposition' = 5],
     [syndrome(packet1, 5), 6 \= 5, received_bit(packet1, 6, 1)]).
step(6 \= 5, builtin, [], []).
step(corrected_bit(packet1, 7, 0),
     rule(16),
     ['Code' = packet1, 'Position' = 7, 'Bit' = 0, 'Errorposition' = 5],
     [syndrome(packet1, 5), 7 \= 5, received_bit(packet1, 7, 0)]).
step(7 \= 5, builtin, [], []).
step(decodedPayload(packet1, [1, 0, 1, 0]),
     rule(21),
     ['Code' = packet1, 'Payload' = [1, 0, 1, 0]],
     [decoded_payload(packet1, [1, 0, 1, 0])]).
step(decoded_payload(packet1, [1, 0, 1, 0]),
     rule(18),
     ['Code' = packet1, 'D1' = 1, 'D2' = 0, 'D3' = 1, 'D4' = 0],
     [corrected_bit(packet1, 3, 1),
      corrected_bit(packet1, 5, 0),
      corrected_bit(packet1, 6, 1),
      corrected_bit(packet1, 7, 0)]).
step(status(packet1, single_bit_corrected),
     rule(22),
     ['Code' = packet1, 'Position' = 5],
     [syndrome(packet1, 5), 5 > 0]).
step(reason(packet1, "Hamming syndrome identifies the flipped bit position"),
     rule(23),
     ['Code' = packet1, 'Position' = 5],
     [syndrome(packet1, 5), 5 > 0]).
