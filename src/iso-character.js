// ISO/IEC 13211-1 processor-character-set choices used by EyeProlog.
//
// The PCS is implementation defined (6.5), so --iso-strict must not replace
// the processor's ordinary character repertoire with a smaller one. EyeProlog
// uses Unicode scalar values in both normal and strict profiles. Strict mode
// still rejects implementation-specific language features; it does not alter
// implementation-defined character-set choices.

export class CharacterRepresentationError extends Error {
  constructor(formal = 'representation_error(character)') {
    super(`error(${formal})`);
    this.name = 'CharacterRepresentationError';
    this.formal = formal;
  }
}

export function isStrictIsoPcsCodePoint(code) {
  return Number.isInteger(code) && code >= 0 && code <= 0x10ffff &&
    !(code >= 0xd800 && code <= 0xdfff);
}

export function isStrictIsoPcsCharacter(character) {
  if (typeof character !== 'string' || Array.from(character).length !== 1) return false;
  return isStrictIsoPcsCodePoint(character.codePointAt(0));
}
