export interface EyePrologStats {
  /** Alternating-fixed-point rounds used to build WFS models. */
  wfs_fixpoint_rounds: number;
  /** Undefined WFS atoms encountered while resolving query goals. */
  wfs_undefined_answers: number;
  [key: string]: number;
}

export interface EyePrologRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | EyePrologTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | EyePrologTerm>;
  proof?: boolean;
  /** Proof detail: abstract keeps library predicates as trusted leaves; expanded opens bundled Prolog library clauses. */
  proofDetail?: 'abstract' | 'expanded';
  why?: boolean;
  explain?: boolean;
  maxDepth?: number;
  maxInferences?: number;
  /** Soft JavaScript heap ceiling in bytes; exhaustion raises resource_error(memory). */
  maxMemoryBytes?: number;
  solutionLimit?: number;
  registry?: BuiltinRegistry;
  sourceMetadata?: boolean;
  strictNegation?: boolean;
  analyzeNegation?: boolean;
  /** Restrict parsing and execution to ISO/IEC 13211-1:1995 plus Corrigenda 1-3. */
  isoStrict?: boolean;
  /** Autoload uniquely mapped predicates from the conservative interop profile. Defaults to true outside strict ISO mode. */
  autoload?: boolean;
  /** Automatically table recursive user predicates in normal mode. Defaults to true; set false for traditional depth-first control. */
  /** Initial ISO interpretation of double-quoted list notation. Defaults to chars. */
  doubleQuotes?: 'chars' | 'codes' | 'atom';
  ioOptions?: {
    input?: string;
    write?: (text: string) => void;
    errorWrite?: (text: string) => void;
  };
  [key: string]: unknown;
}

export interface EyePrologRunResult {
  stdout: string;
  stats: EyePrologStats;
  haltCode: number | null;
}

export interface EyePrologForwardRunResult {
  haltCode: number | null;
  rounds: number;
  derived: number;
}

export interface EyePrologForwardRunOptions {
  onAnswer?: (line: string, term: EyePrologTerm) => void;
  onFuse?: (line: string, term: EyePrologTerm) => void;
  onDiagnostic?: (line: string) => void;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyePrologSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyePrologClause {
  head: EyePrologTerm;
  body: EyePrologTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
  module?: string;
}

export interface EyePrologQuad {
  kind: 'quad';
  id: EyePrologTerm | null;
  query: EyePrologTerm;
  answers: EyePrologTerm[];
  module?: string;
  source: { filename: string; line: number };
}

export interface EyePrologQuadResult {
  ok: boolean;
  kind?: 'failed' | 'malformed' | 'bad_identifier' | 'unsupported' | 'undecided';
  expected?: EyePrologTerm;
  reason?: string;
  /** The quad's query term, for a caller building its own per-result label. */
  query?: EyePrologTerm;
  /** The quad's identifier, or null when the quad has none. */
  id?: EyePrologTerm | null;
  /** The source line this answer description starts on, when known. */
  line?: number | null;
}

export interface EyePrologQuadRunResult {
  stdout: string;
  total: number;
  passed: number;
  failed: number;
  undecided: number;
  results: EyePrologQuadResult[];
}

export interface EyePrologQuadRunOptions extends EyePrologRunOptions {
  initialize?: boolean;
  /** Search budget for ordinary quad descriptions before reporting an undecided result. */
  quadMaxInferences?: number;
  /** Depth bound used when a quad explicitly expects loops. */
  loopMaxDepth?: number;
  /** Inference bound used when a quad explicitly expects loops. */
  loopMaxInferences?: number;
}

export interface EyePrologPredicateGroup {
  name: string;
  arity: number;
  module: string;
  clauses: EyePrologClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  listTailRecursive: boolean;
  tableInputPositions: number[];
  tableAllVariants: boolean;
  /** True when the group is evaluated by EyeProlog's finite-Datalog WFS evaluator. */
  wfsDatalog: boolean;
  negationStratum: number | null;
}

export type EyePrologTerm = Term | { type: string; name: string; args?: EyePrologTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyePrologTerm[]);
  type: string;
  name: string;
  args: EyePrologTerm[];
  get arity(): number;
}

export class CompactListTerm {
  readonly type: 'compound';
  readonly name: '.';
  readonly args: EyePrologTerm[];
  readonly arity: 2;
  mayContainVariable(name: string): boolean;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyePrologTerm]> | null);
  bindings: Map<string, EyePrologTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyePrologTerm | undefined;
  bind(name: string, term: EyePrologTerm): void;
}

export class Program {
  constructor(clauses?: EyePrologClause[], options?: EyePrologRunOptions);
  clauses: EyePrologClause[];
  groups: Map<string, EyePrologPredicateGroup>;
  modules: Map<string, { name: string; exports: Map<string, unknown>; filename: string }>;
  moduleImports: Map<string, Map<string, string>>;
  quads: EyePrologQuad[];
  doubleQuotes: 'chars' | 'codes' | 'atom';
  strictIso: boolean;
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyePrologRunOptions): Program;
  static parseSources(sources?: Array<string | EyePrologSourcePart>, options?: EyePrologRunOptions): Program;
  makeGroup(name: string, arity: number): EyePrologPredicateGroup;
  indexClause(clause: EyePrologClause): void;
  findGroup(name: string, arity: number, module?: string): EyePrologPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyePrologPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null, options?: { doubleQuotes?: 'chars' | 'codes' | 'atom' }): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: EyePrologTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: EyePrologTerm; env: Env }) => boolean) | null;
  eyePrologLibrary: boolean;
}

export interface BuiltinIterator extends IterableIterator<Env> {
  hasPendingAlternatives?: () => boolean;
}

export type BuiltinHandler =
  (context: { solver: Solver; goal: EyePrologTerm; env: Env }) => BuiltinIterator;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  eyePrologLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
  remove(name: string, arity: number): this;
}

export class Solver {
  constructor(program: Program, options?: EyePrologRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  isoStrict: boolean;
  maxDepth: number;
  depthLimitExceeded: boolean;
  maxInferences: number;
  inferences: number;
  inferenceLimitExceeded: boolean;
  maxMemoryBytes: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyePrologStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyePrologTerm | EyePrologTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyePrologTerm, env: Env): boolean;
}

export const VAR: 'var';
export const ATOM: 'atom';
export const STRING: 'string';
export const NUMBER: 'number';
export const COMPOUND: 'compound';

export function variable(name: string): Term;
export function atom(name: string): Term;
export function stringTerm(value: string): Term;
export function numberTerm(value: string | number): Term;
/** Construct a compound term; an empty argument list is canonicalized to atom(name). */
export function compound(name: string, args?: EyePrologTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyePrologTerm, tail: EyePrologTerm): Term;
export function compactVariableList(length: bigint | number | string, variablePrefix: string): CompactListTerm | Term;
export function isCompactList(term: EyePrologTerm | null | undefined): term is CompactListTerm;
export function compactListLength(term: EyePrologTerm | null | undefined): bigint | null;
export function deref(term: EyePrologTerm, env: Env): EyePrologTerm;
export function isScalar(term: EyePrologTerm | null | undefined): boolean;
export function isEmptyList(term: EyePrologTerm | null | undefined): boolean;
export function isCons(term: EyePrologTerm | null | undefined): boolean;
export function isConjunction(term: EyePrologTerm | null | undefined): boolean;
export function unify(left: EyePrologTerm, right: EyePrologTerm, env: Env): boolean;
export function cloneTerm(term: EyePrologTerm): Term;
export function freshTerm(term: EyePrologTerm, suffix: string | number): Term;
export function copyResolved(term: EyePrologTerm, env: Env): Term;
export function termIsGround(term: EyePrologTerm, env?: Env): boolean;
export function termToString(term: EyePrologTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyePrologTerm, env: Env): string | null;
export function properListItems(list: EyePrologTerm, env: Env): EyePrologTerm[] | null;
export function listFromItems(items: EyePrologTerm[], start?: number, end?: number, tail?: EyePrologTerm): Term;
export function flattenConjunction(goal: EyePrologTerm): EyePrologTerm[];
export function termSignature(term: EyePrologTerm | null | undefined): string | null;
export function variantTerms(left: EyePrologTerm, leftEnv: Env, right: EyePrologTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyePrologTerm, right: EyePrologTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyePrologRunOptions): Program;
export function parseClauses(source: string, options?: EyePrologRunOptions): Array<EyePrologClause | EyePrologQuad>;
export function parseProgramText(source: string, options?: EyePrologRunOptions): Array<EyePrologClause | EyePrologQuad>;
export function parseGoalText(source: string, options?: EyePrologRunOptions): EyePrologTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createStrictIsoRegistry(): BuiltinRegistry;
export function createEyePrologRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getStrictIsoRegistry(): BuiltinRegistry;
export function getEyePrologRegistry(): BuiltinRegistry;
export const standardLibrarySources: ReadonlyMap<string, { filename: string; source: string }>;
export const eyePrologLibraryIndicators: readonly string[];
export const eyePrologNativeLibraryIndicators: readonly string[];
export const eyePrologPortableLibraryIndicators: readonly string[];
export const eyePrologInteropAutoload: Readonly<Record<string, string>>;
export const eyePrologLibraryAutoload: Readonly<Record<string, string>>;
export const eyePrologAmbiguousLibraryAutoload: Readonly<Record<string, readonly string[]>>;
export const eyePrologLibraryAutoloadModules: readonly string[];
export const eyePrologInteropLibraryIndicators: readonly string[];
export const eyePrologInteropLibraryModules: readonly string[];
export class PrologError extends Error {
  formal: string;
  culprit: EyePrologTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyePrologRunOptions): EyePrologRunResult;
/** True when a program contains one or more EyeProlog `:+/2` forward rules. */
export function hasForwardRules(program: Program): boolean;
/** Execute EyeProlog `:+/2` rules to closure using an existing solver. */
export function executeForwardRules(program: Program, solver: Solver, options?: EyePrologForwardRunOptions): EyePrologForwardRunResult;
export function runQuads(source: string | Program, options?: EyePrologQuadRunOptions): EyePrologQuadRunResult;
/** Render a quad term (query, identifier, or expected answer) the way quad failure reports do. */
export function formatQuadTerm(program: Program, term: EyePrologTerm): string;
export interface EyePrologProofMethod {
  type: 'source' | 'builtin' | 'library' | 'conjunction';
  kind?: 'fact' | 'rule';
  filename?: string;
  clause?: number;
  name?: string;
  arity?: number;
}

export interface EyePrologProofNode {
  goal: string;
  method: EyePrologProofMethod;
  bindings: Array<{ name: string; value: string }>;
  children: EyePrologProofNode[];
}

export interface EyePrologProofCertificate {
  version: 1;
  detail: 'abstract' | 'expanded';
  answer: string;
  proof: EyePrologProofNode;
}

export interface EyePrologProofResult {
  ok: boolean;
  certificate: EyePrologProofCertificate | null;
  text: string;
}

export interface EyePrologProofTrustBoundary {
  type: 'builtin' | 'library';
  name: string;
  arity: number;
  goal: string;
}

export interface EyePrologProofVerification {
  ok: boolean;
  error: string | null;
  trusted: EyePrologProofTrustBoundary[];
}

export function proofCertificate(program: Program, goal: EyePrologTerm, options?: EyePrologRunOptions): EyePrologProofResult;
export function proofCertificatesFromText(text: string, program: Program): EyePrologProofCertificate[];
export function verifyProof(program: Program, certificate: EyePrologProofCertificate | EyePrologProofResult, options?: EyePrologRunOptions): EyePrologProofVerification;
export function whyProof(program: Program, goal: EyePrologTerm, options?: EyePrologRunOptions): EyePrologProofResult;
export function whyNoProof(goal: EyePrologTerm): string;
export function explainProof(program: Program, goal: EyePrologTerm, options?: EyePrologRunOptions): EyePrologProofResult;

declare const eyeprolog: {
  VAR: typeof VAR;
  ATOM: typeof ATOM;
  STRING: typeof STRING;
  NUMBER: typeof NUMBER;
  COMPOUND: typeof COMPOUND;
  Term: typeof Term;
  CompactListTerm: typeof CompactListTerm;
  Env: typeof Env;
  Program: typeof Program;
  Solver: typeof Solver;
  BuiltinRegistry: typeof BuiltinRegistry;
  PrologError: typeof PrologError;
  HaltSignal: typeof HaltSignal;
  StreamManager: typeof StreamManager;
  variable: typeof variable;
  atom: typeof atom;
  stringTerm: typeof stringTerm;
  numberTerm: typeof numberTerm;
  compound: typeof compound;
  emptyList: typeof emptyList;
  cons: typeof cons;
  compactVariableList: typeof compactVariableList;
  isCompactList: typeof isCompactList;
  compactListLength: typeof compactListLength;
  deref: typeof deref;
  isScalar: typeof isScalar;
  isEmptyList: typeof isEmptyList;
  isCons: typeof isCons;
  isConjunction: typeof isConjunction;
  unify: typeof unify;
  cloneTerm: typeof cloneTerm;
  freshTerm: typeof freshTerm;
  copyResolved: typeof copyResolved;
  termIsGround: typeof termIsGround;
  termToString: typeof termToString;
  lexicalValue: typeof lexicalValue;
  properListItems: typeof properListItems;
  listFromItems: typeof listFromItems;
  flattenConjunction: typeof flattenConjunction;
  termSignature: typeof termSignature;
  variantTerms: typeof variantTerms;
  compareTerms: typeof compareTerms;
  isDecimalInteger: typeof isDecimalInteger;
  compareIntegerText: typeof compareIntegerText;
  parseFiniteNumber: typeof parseFiniteNumber;
  numberTextFromDouble: typeof numberTextFromDouble;
  compareNumberText: typeof compareNumberText;
  makeProgram: typeof makeProgram;
  parseClauses: typeof parseClauses;
  parseGoalText: typeof parseGoalText;
  parseProgramText: typeof parseProgramText;
  createDefaultRegistry: typeof createDefaultRegistry;
  createStrictIsoRegistry: typeof createStrictIsoRegistry;
  createEyePrologRegistry: typeof createEyePrologRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getStrictIsoRegistry: typeof getStrictIsoRegistry;
  getEyePrologRegistry: typeof getEyePrologRegistry;
  standardLibrarySources: typeof standardLibrarySources;
  eyePrologLibraryIndicators: typeof eyePrologLibraryIndicators;
  eyePrologNativeLibraryIndicators: typeof eyePrologNativeLibraryIndicators;
  eyePrologPortableLibraryIndicators: typeof eyePrologPortableLibraryIndicators;
  eyePrologInteropAutoload: typeof eyePrologInteropAutoload;
  eyePrologLibraryAutoload: typeof eyePrologLibraryAutoload;
  eyePrologAmbiguousLibraryAutoload: typeof eyePrologAmbiguousLibraryAutoload;
  eyePrologLibraryAutoloadModules: typeof eyePrologLibraryAutoloadModules;
  eyePrologInteropLibraryIndicators: typeof eyePrologInteropLibraryIndicators;
  eyePrologInteropLibraryModules: typeof eyePrologInteropLibraryModules;
  run: typeof run;
  hasForwardRules: typeof hasForwardRules;
  executeForwardRules: typeof executeForwardRules;
  runQuads: typeof runQuads;
  formatQuadTerm: typeof formatQuadTerm;
  proofCertificate: typeof proofCertificate;
  proofCertificatesFromText: typeof proofCertificatesFromText;
  verifyProof: typeof verifyProof;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyeprolog;
