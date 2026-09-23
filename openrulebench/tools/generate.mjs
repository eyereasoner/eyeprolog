#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const TOOL_DIR = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.dirname(TOOL_DIR);
const HEADER = `% OpenRuleBench -> EyeProlog portable benchmark\n% Generated deterministically by tools/generate.mjs.\n% See ../README.md for provenance and fidelity notes.\n\n`;

// Preserve the historical generator's MT19937 integer-seed and sample(range)
// behavior so benchmark data stays byte-stable.
class DeterministicRandom {
  constructor(seed) {
    this.mt = new Uint32Array(624);
    this.index = 624;
    this.seed(seed);
  }

  initGenrand(seed) {
    this.mt[0] = seed >>> 0;
    for (let i = 1; i < 624; i++) {
      const x = (this.mt[i - 1] ^ (this.mt[i - 1] >>> 30)) >>> 0;
      this.mt[i] = (Math.imul(1812433253, x) + i) >>> 0;
    }
    this.index = 624;
  }

  initByArray(key) {
    this.initGenrand(19650218);
    let i = 1;
    let j = 0;
    for (let k = Math.max(624, key.length); k > 0; k--) {
      const previous = this.mt[i - 1];
      const x = (previous ^ (previous >>> 30)) >>> 0;
      this.mt[i] = ((this.mt[i] ^ Math.imul(x, 1664525)) + (key[j] >>> 0) + j) >>> 0;
      i++;
      j++;
      if (i >= 624) {
        this.mt[0] = this.mt[623];
        i = 1;
      }
      if (j >= key.length) j = 0;
    }
    for (let k = 623; k > 0; k--) {
      const previous = this.mt[i - 1];
      const x = (previous ^ (previous >>> 30)) >>> 0;
      this.mt[i] = ((this.mt[i] ^ Math.imul(x, 1566083941)) - i) >>> 0;
      i++;
      if (i >= 624) {
        this.mt[0] = this.mt[623];
        i = 1;
      }
    }
    this.mt[0] = 0x80000000;
  }

  seed(seed) {
    let value = BigInt(seed);
    if (value < 0n) value = -value;
    const key = [];
    do {
      key.push(Number(value & 0xffffffffn));
      value >>= 32n;
    } while (value > 0n);
    this.initByArray(key);
  }

  uint32() {
    const N = 624;
    const M = 397;
    const MATRIX_A = 0x9908b0df;
    const UPPER_MASK = 0x80000000;
    const LOWER_MASK = 0x7fffffff;
    if (this.index >= N) {
      let y;
      for (let k = 0; k < N - M; k++) {
        y = (this.mt[k] & UPPER_MASK) | (this.mt[k + 1] & LOWER_MASK);
        this.mt[k] = (this.mt[k + M] ^ (y >>> 1) ^ ((y & 1) ? MATRIX_A : 0)) >>> 0;
      }
      for (let k = N - M; k < N - 1; k++) {
        y = (this.mt[k] & UPPER_MASK) | (this.mt[k + 1] & LOWER_MASK);
        this.mt[k] = (this.mt[k + (M - N)] ^ (y >>> 1) ^ ((y & 1) ? MATRIX_A : 0)) >>> 0;
      }
      y = (this.mt[N - 1] & UPPER_MASK) | (this.mt[0] & LOWER_MASK);
      this.mt[N - 1] = (this.mt[M - 1] ^ (y >>> 1) ^ ((y & 1) ? MATRIX_A : 0)) >>> 0;
      this.index = 0;
    }
    let y = this.mt[this.index++];
    y ^= y >>> 11;
    y ^= (y << 7) & 0x9d2c5680;
    y ^= (y << 15) & 0xefc60000;
    y ^= y >>> 18;
    return y >>> 0;
  }

  getrandbits(bits) {
    if (bits <= 0) return 0;
    if (bits <= 32) return this.uint32() >>> (32 - bits);
    throw new Error(`unsupported getrandbits width: ${bits}`);
  }

  randbelow(limit) {
    const bits = 32 - Math.clz32(limit);
    let value = this.getrandbits(bits);
    while (value >= limit) value = this.getrandbits(bits);
    return value;
  }

  sampleRange(limit, count) {
    if (count < 0 || count > limit) throw new RangeError('sample larger than population or is negative');
    let setsize = 21;
    if (count > 5) setsize += 4 ** Math.ceil(Math.log(count * 3) / Math.log(4));
    const result = [];
    if (limit <= setsize) {
      const pool = Array.from({ length: limit }, (_, i) => i);
      for (let i = 0; i < count; i++) {
        const j = this.randbelow(limit - i);
        result.push(pool[j]);
        pool[j] = pool[limit - i - 1];
      }
    } else {
      const selected = new Set();
      for (let i = 0; i < count; i++) {
        let j = this.randbelow(limit);
        while (selected.has(j)) j = this.randbelow(limit);
        selected.add(j);
        result.push(j);
      }
    }
    return result;
  }
}

function write(file, text) {
  fs.writeFileSync(file, HEADER + text, 'utf8');
}

function pairs(count, domain, seed) {
  const random = new DeterministicRandom(seed);
  return random.sampleRange(domain * domain, count)
    .map((value) => [Math.floor(value / domain) + 1, value % domain + 1]);
}

function facts2(predicate, values) {
  return values.map(([a, b]) => `${predicate}(${a},${b}).\n`).join('');
}

function genJoin1(out, rows = 10000, domain = 1000) {
  const rules = `a(X,Y) :- b1(X,Z), b2(Z,Y).
b1(X,Y) :- c1(X,Z), c2(Z,Y).
b2(X,Y) :- c3(X,Z), c4(Z,Y).
c1(X,Y) :- d1(X,Z), d2(Z,Y).

benchmark_ff(Count) :- findall(pair(X,Y), a(X,Y), A), length(A, Count).
benchmark_bf(Count) :- findall(Y, a(1,Y), A), length(A, Count).
benchmark_fb(Count) :- findall(X, a(X,1), A), length(A, Count).
%% ?- benchmark_ff(Count).
`;
  let data = '';
  ['c2', 'c3', 'c4', 'd1', 'd2'].forEach((predicate, i) => { data += facts2(predicate, pairs(rows, domain, 101 + i)); });
  write(path.join(out, 'join1.pl'), rules + data);
}

function genJoindup(out, rows = 10000, domain = 1000) {
  const parts = [];
  for (let i = 1; i <= 5; i++) {
    parts.push(
      `a${i}(X,Y) :- b1_${i}(X,Z), b2_${i}(Z,Y).\n`,
      `b1_${i}(X,Y) :- c1_${i}(X,Z), c2(Z,Y).\n`,
      `b2_${i}(X,Y) :- c3(X,Z), c4(Z,Y).\n`,
      `c1_${i}(X,Y) :- d1(X,Z), d2(Z,Y).\n`,
    );
  }
  for (let i = 1; i <= 5; i++) parts.push(`a(X,Y) :- a${i}(X,Y).\n`);
  parts.push('\nbenchmark(Count) :- findall(pair(X,Y), a(X,Y), A), length(A, Count).\n%% ?- benchmark(Count).\n\n');
  ['c2', 'c3', 'c4', 'd1', 'd2'].forEach((predicate, i) => parts.push(facts2(predicate, pairs(rows, domain, 201 + i))));
  write(path.join(out, 'joindup.pl'), parts.join(''));
}

function genJoin2(out) {
  const rules = `ra(A,B,C,D,E) :- p(A), p(B), p(C), p(D), p(E).
rb(A,B,C,D,E) :- p(A), p(B), p(C), p(D), p(E).
r(A,B,C,D,E) :- ra(A,B,C,D,E), rb(A,B,C,D,E).
q1(A) :- r(A,_,_,_,_).
q2(B) :- r(_,B,_,_,_).
q3(C) :- r(_,_,C,_,_).
q4(D) :- r(_,_,_,D,_).
q5(E) :- r(_,_,_,_,E).
benchmark(Count) :- findall(A, q1(A), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  const data = Array.from({ length: 19 }, (_, i) => `p(a${i}).\n`).join('');
  write(path.join(out, 'join2.pl'), rules + data);
}

function genTc(out, edges = 50000, domain = 1000) {
  const rules = `tc(X,Y) :- par(X,Y).
tc(X,Y) :- par(X,Z), tc(Z,Y).
benchmark(Count) :- findall(pair(X,Y), tc(X,Y), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  write(path.join(out, 'tc.pl'), rules + facts2('par', pairs(edges, domain, 301)));
}

function sgData(total, domain, seed) {
  const half = Math.floor(total / 2);
  return facts2('par', pairs(half, domain, seed)) + facts2('sib', pairs(total - half, domain, seed + 1));
}

function genSg(out, total = 6000, domain = 1000) {
  const rules = `sg(X,Y) :- sib(X,Y).
sg(X,Y) :- par(X,Z), sg(Z,Z1), par(Y,Z1).
benchmark(Count) :- findall(pair(X,Y), sg(X,Y), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  write(path.join(out, 'sg.pl'), rules + sgData(total, domain, 401));
}

function genModsg(out, total = 6000, domain = 1000) {
  const rules = `tc(X,Y) :- par(X,Y).
tc(X,Y) :- par(X,Z), tc(Z,Y).
sg(X,Y) :- sib(X,Y).
sg(X,Y) :- par(X,Z), sg(Z,Z1), par(Y,Z1).
nonsg(X,Y) :- tc(X,Y).
nonsg(X,Y) :- tc(Y,X).
sg2(X,Y) :- sg(X,Y), \\+ nonsg(X,Y).
benchmark(Count) :- findall(pair(X,Y), sg2(X,Y), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  write(path.join(out, 'modsg.pl'), rules + sgData(total, domain, 501));
}

function genWin(out, n = 10000) {
  const rule = `win(X) :- move(X,Y), \\+ win(Y).
benchmark(Count) :- findall(X, win(X), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  let tree = '';
  for (let i = 1; i <= n; i++) tree += `move(${i},${2 * i}).\nmove(${i},${2 * i + 1}).\n`;
  let cycle = '';
  for (let i = 1; i < n; i++) cycle += `move(${i},${i + 1}).\n`;
  cycle += `move(${n},1).\n`;
  write(path.join(out, 'win_tree.pl'), '% Locally stratified Win instance (scaled portable data).\n' + rule + tree);
  write(path.join(out, 'win_cycle.pl'), '% Non-locally-stratified Win instance; requires well-founded negation for ORB-equivalent semantics.\n' + rule + cycle);
}

function genMagicset(out, edgeRows = 24000, domain = 1000) {
  const rules = `% Non-stratified after magic-set transformation; ORB semantics is well-founded negation.
fb(X) :- magicfb(X), d(X), \\+ ab(X), h(X,Y), ab(Y).
ab(X) :- magicab(X), g(X).
ab(X) :- magicab(X), b(X,Y), ab(Y).
magicab(Y) :- magicab(X), b(X,Y).
magicab(Y) :- magicfb(X), d(X), \\+ ab(X), h(X,Y).
magicab(X) :- magicfb(X), d(X).
benchmark(Count) :- findall(X, fb(X), Answers), length(Answers, Count).
%% ?- benchmark(Count).
magicfb(1).
`;
  let unaries = '';
  for (let i = 1; i <= domain; i++) unaries += `d(${i}).\n`;
  for (let i = 1; i <= domain; i += 17) unaries += `g(${i}).\n`;
  const data = facts2('b', pairs(edgeRows, domain, 601)) + facts2('h', pairs(edgeRows, domain, 602));
  write(path.join(out, 'magicset.pl'), rules + unaries + data);
}

function genDblp(out, pubs = 20000) {
  const rules = `q(Id,T,A,Y,M) :- att(Id,title,T), att(Id,year,Y), att(Id,author,A), att(Id,month,M).
benchmark(Count) :- findall(row(Id,T,A,Y,M), q(Id,T,A,Y,M), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  const parts = [rules];
  for (let i = 1; i <= pubs; i++) {
    const pid = `pub${i}`;
    parts.push(
      `att(${pid},title,title${i}).\n`,
      `att(${pid},year,y${1990 + i % 35}).\n`,
      `att(${pid},author,author${i % 5000}).\n`,
      `att(${pid},month,m${1 + i % 12}).\n`,
      `att(${pid},venue,venue${i % 300}).\n`,
      `att(${pid},type,article).\n`,
    );
    if (i % 3 === 0) parts.push(`att(${pid},author,author${(i + 733) % 5000}).\n`);
  }
  write(path.join(out, 'dblp.pl'), parts.join(''));
}

function genLubm(out, universities = 10, departments = 10, students = 100, faculty = 10, courses = 10) {
  const rules = `query1(X) :- takesCourse(X,graduateCourse0), graduateStudent(X).
query2(X,Y,Z) :- graduateStudent(X), memberOf(X,Z), undergraduateDegreeFrom(X,Y), university(Y), department(Z), subOrganizationOf_0(Z,Y).
query9(X,Y,Z) :- advisor(X,Y), teacherOf(Y,Z), takesCourse(X,Z), student(X), faculty(Y), course(Z).
benchmark(Count) :- findall(X, query1(X), Answers), length(Answers, Count).
%% ?- benchmark(Count).
course(graduateCourse0).
`;
  const parts = [rules];
  for (let u = 0; u < universities; u++) {
    const un = `u${u}`;
    parts.push(`university(${un}).\n`);
    for (let d = 0; d < departments; d++) {
      const dep = `dep${u}_${d}`;
      parts.push(`department(${dep}).\n`, `subOrganizationOf_0(${dep},${un}).\n`);
      const facultyNames = [];
      const courseNames = [];
      for (let f = 0; f < faculty; f++) {
        const fac = `fac${u}_${d}_${f}`;
        facultyNames.push(fac);
        parts.push(`faculty(${fac}).\n`);
      }
      for (let c = 0; c < courses; c++) {
        const course = `course${u}_${d}_${c}`;
        courseNames.push(course);
        parts.push(`course(${course}).\n`, `teacherOf(${facultyNames[c % facultyNames.length]},${course}).\n`);
      }
      for (let j = 0; j < students; j++) {
        const student = `stu${u}_${d}_${j}`;
        const fac = facultyNames[j % facultyNames.length];
        const course = courseNames[j % courseNames.length];
        parts.push(
          `graduateStudent(${student}).\n`,
          `student(${student}).\n`,
          `memberOf(${student},${dep}).\n`,
          `undergraduateDegreeFrom(${student},u${(u + universities - 1) % universities}).\n`,
          `advisor(${student},${fac}).\n`,
          `takesCourse(${student},${course}).\n`,
        );
        if (j === 0) parts.push(`takesCourse(${student},graduateCourse0).\n`);
      }
    }
  }
  write(path.join(out, 'lubm.pl'), parts.join(''));
}

function genWordnet(out, synsets = 15000) {
  const rules = `% Structural WordNet 3.0 port: same predicate shape and recursive query kernels, synthetic lexicon data.
hypernyms(W1,W2) :- s(S1,_,W1,_,_,_), hypernym_synsets(S1,S2), s(S2,_,W2,_,_,_).
hypernym_synsets(S1,S2) :- hypernym(S1,S2).
hypernym_synsets(S1,S2) :- hypernym(S1,S3), hypernym_synsets(S3,S2).
hyponyms(W1,W2) :- hypernyms(W2,W1).
meronyms(W1,W2) :- s(S1,_,W1,_,_,_), meronym_synsets(S1,S2), s(S2,_,W2,_,_,_).
meronym_synsets(S1,S2) :- meronym(S1,S2).
meronym_synsets(S1,S2) :- meronym(S1,S3), meronym_synsets(S3,S2).
holonyms(W1,W2) :- meronyms(W2,W1).
troponyms(W1,W2) :- s(S1,_,W1,_,_,_), troponym_synsets(S1,S2), s(S2,_,W2,_,_,_).
troponym_synsets(S1,S2) :- troponym(S1,S2).
troponym_synsets(S1,S2) :- troponym(S1,S3), troponym_synsets(S3,S2).
same_synset(W1,W2) :- s(S,_,W1,_,_,_), s(S,_,W2,_,_,_), W1 \\= W2.
gloss(W,G) :- s(S,_,W,_,_,_), gloss_fact(S,G).
antonyms(W1,W2) :- s(S1,_,W1,_,_,_), antonym_synsets(S1,S2), s(S2,_,W2,_,_,_).
adjective_clusters(W1,W2) :- s(S1,_,W1,_,_,_), similar_synsets(S1,S2), s(S2,_,W2,_,_,_).
benchmark(Count) :- findall(pair(W1,W2), hypernyms(W1,W2), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  const parts = [rules];
  for (let i = 1; i <= synsets; i++) {
    const synset = `s${i}`;
    parts.push(`s(${synset},1,word${i}a,n,1,0).\n`, `s(${synset},2,word${i}b,n,1,0).\n`, `gloss_fact(${synset},gloss${i}).\n`);
    if (i > 1) parts.push(`hypernym(${synset},s${Math.floor(i / 2)}).\n`);
    if (i > 10 && i % 5 === 0) parts.push(`meronym(${synset},s${Math.floor(i / 5)}).\n`);
    if (i > 20 && i % 23 === 0) parts.push(`troponym(${synset},s${Math.floor(i / 23)}).\n`);
    if (i % 97 === 0 && i + 1 <= synsets) parts.push(`antonym_synsets(${synset},s${i + 1}).\n`);
    if (i % 31 === 0 && i + 1 <= synsets) parts.push(`similar_synsets(${synset},s${i + 1}).\n`);
  }
  write(path.join(out, 'wordnet.pl'), parts.join(''));
}

function genMondial(out, countries = 100, provinces = 20, cities = 10) {
  const rules = `% Structural Mondial port. OpenRuleBench uses compound terms such as prov(Y,X).
province_stat(P,Area,Population,City,CityPopulation) :-
    isa(prov(P,china),provi),
    att(prov(P,china),area,Area),
    att(prov(P,china),population,Population),
    located(City,prov(P,china)),
    att(City,population,CityPopulation).
benchmark(Count) :- findall(row(P,A,N,C,CN), province_stat(P,A,N,C,CN), Answers), length(Answers, Count).
%% ?- benchmark(Count).
`;
  const parts = [rules];
  for (let ci = 0; ci < countries; ci++) {
    const country = ci === 0 ? 'china' : `country${ci}`;
    parts.push(`isa(${country},country).\n`);
    for (let pi = 0; pi < provinces; pi++) {
      const province = `p${ci}_${pi}`;
      const term = `prov(${province},${country})`;
      parts.push(`isa(${term},provi).\n`, `att(${term},area,${1000 + pi * 17 + ci}).\n`, `att(${term},population,${100000 + ci * 1000 + pi * 100}).\n`);
      for (let cityIndex = 0; cityIndex < cities; cityIndex++) {
        const city = `city${ci}_${pi}_${cityIndex}`;
        parts.push(`isa(${city},city).\n`, `located(${city},${term}).\n`, `att(${city},population,${10000 + cityIndex * 100 + pi}).\n`);
      }
    }
  }
  write(path.join(out, 'mondial.pl'), parts.join(''));
}

function genWine(out) {
  const predicates = ['wine', ...Array.from({ length: 224 }, (_, i) => `w${String(i + 1).padStart(3, '0')}`)];
  const edbs = Array.from({ length: 113 }, (_, i) => `e${String(i).padStart(3, '0')}`);
  const rules = [];
  const n = predicates.length;
  predicates.forEach((predicate, i) => {
    const previous = predicates[(i - 1 + n) % n];
    const next = predicates[(i + 1) % n];
    const alternate = predicates[(i + 17) % n];
    const e1 = edbs[i % edbs.length];
    const e2 = edbs[(i * 7 + 3) % edbs.length];
    rules.push(
      `${predicate}(X) :- ${previous}(X).\n`,
      `${predicate}(X) :- ${next}(X).\n`,
      `${predicate}(X) :- ${e1}(X,Y), ${previous}(Y).\n`,
      `${predicate}(X) :- ${alternate}(Y), ${e2}(Y,X).\n`,
    );
  });
  for (let i = 0; i < 61; i++) rules.push(`${predicates[i]}(X) :- ${edbs[(i * 11) % edbs.length]}(X,_).\n`);
  if (rules.length !== 961) throw new Error(`wine rule count ${rules.length} != 961`);
  const facts = [];
  let total = 0;
  edbs.forEach((edb, i) => {
    const count = i < 89 ? 6 : 5;
    for (let j = 0; j < count; j++) {
      const a = (i * 13 + j) % 400 + 1;
      const b = (i * 29 + j * 7 + 1) % 400 + 1;
      facts.push(`${edb}(item${a},item${b}).\n`);
      total++;
    }
  });
  if (total !== 654) throw new Error(`wine fact count ${total} != 654`);
  let text = '% Structural Wine surrogate: preserves 961-rule / 225-IDB / 113-EDB / 654-fact stress shape; not the historical OWL-to-rules program.\n';
  text += rules.join('');
  text += '\nbenchmark(Count) :- findall(X, wine(X), Answers), length(Answers, Count).\n%% ?- benchmark(Count).\n\n';
  text += facts.join('');
  write(path.join(out, 'wine.pl'), text);
}

function profileValues(name) {
  if (name === 'smoke') return { joinRows: 1000, joinDomain: 1000, tcEdges: 1250, tcDomain: 500, sgTotal: 500, sgDomain: 500, winN: 1000, magicEdges: 2000, dblpPubs: 2000, lubmU: 3, lubmD: 4, lubmS: 20, wordnet: 2000, mondialC: 20, mondialP: 10, mondialCity: 5 };
  if (name === 'portable') return { joinRows: 3500, joinDomain: 1000, tcEdges: 12500, tcDomain: 500, sgTotal: 1500, sgDomain: 500, winN: 5000, magicEdges: 12000, dblpPubs: 15000, lubmU: 6, lubmD: 8, lubmS: 60, wordnet: 10000, mondialC: 60, mondialP: 15, mondialCity: 8 };
  if (name === 'orb-small') return { joinRows: 10000, joinDomain: 1000, tcEdges: 50000, tcDomain: 1000, sgTotal: 6000, sgDomain: 1000, winN: 10000, magicEdges: 24000, dblpPubs: 20000, lubmU: 10, lubmD: 10, lubmS: 100, wordnet: 15000, mondialC: 100, mondialP: 20, mondialCity: 10 };
  throw new Error(`invalid profile: ${name}`);
}

function usage(message = null) {
  if (message) process.stderr.write(`${message}\n`);
  process.stderr.write('usage: node generate.mjs [--profile {smoke,portable,orb-small}] [--output DIR]\n');
  process.exit(message ? 2 : 0);
}

function parseArgs(argv) {
  let profile = 'portable';
  let output = path.join(ROOT, 'benchmarks');
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '-h' || arg === '--help') usage();
    if (arg === '--profile' || arg.startsWith('--profile=')) {
      profile = arg.includes('=') ? arg.slice(arg.indexOf('=') + 1) : argv[++i];
      if (!['smoke', 'portable', 'orb-small'].includes(profile)) usage(`invalid profile: ${profile}`);
      continue;
    }
    if (arg === '--output' || arg.startsWith('--output=')) {
      output = arg.includes('=') ? arg.slice(arg.indexOf('=') + 1) : argv[++i];
      if (output == null) usage('--output requires a value');
      continue;
    }
    usage(`unknown argument: ${arg}`);
  }
  return { profile, output };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const values = profileValues(args.profile);
  fs.rmSync(args.output, { recursive: true, force: true });
  fs.mkdirSync(args.output, { recursive: true });
  genJoin1(args.output, values.joinRows, values.joinDomain);
  genJoin2(args.output);
  genJoindup(args.output, values.joinRows, values.joinDomain);
  genLubm(args.output, values.lubmU, values.lubmD, values.lubmS);
  genMondial(args.output, values.mondialC, values.mondialP, values.mondialCity);
  genDblp(args.output, values.dblpPubs);
  genTc(args.output, values.tcEdges, values.tcDomain);
  genSg(args.output, values.sgTotal, values.sgDomain);
  genWordnet(args.output, values.wordnet);
  genWine(args.output);
  genModsg(args.output, values.sgTotal, values.sgDomain);
  genWin(args.output, values.winN);
  genMagicset(args.output, values.magicEdges);
  const count = fs.readdirSync(args.output).filter((name) => name.endsWith('.pl')).length;
  process.stdout.write(`generated ${count} Prolog files in ${args.output}\n`);
}

main();
