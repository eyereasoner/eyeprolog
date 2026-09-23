syndrome(packet1, 5).
errorBit(packet1, 5).
correctedCodeword(packet1, [1, 0, 1, 1, 0, 1, 0]).
decodedPayload(packet1, [1, 0, 1, 0]).
status(packet1, single_bit_corrected).
reason(packet1, "Hamming syndrome identifies the flipped bit position").
