// Term model, environments, unification, readback, and ordering helpers.
// Keep dependencies minimal because nearly every other module imports this file.
import { compareIntegerValueText, sameNumberValue } from './number-value.js';

export const VAR = 'var';
export const ATOM = 'atom';
export const STRING = 'string';
export const NUMBER = 'number';
export const COMPOUND = 'compound';
const EMPTY_ARGS = Object.freeze([]);
// Deep persistent binding chains make the many negative variable lookups in
// constraint propagation linear in the complete history. Periodically fold
// the chain into its indexed Map before that lookup cost dominates. Ordinary
// execution keeps the memory-friendly 512-layer threshold; attributed-variable
// propagation uses 256 because its repeated negative lookups dominate sooner.
const ENV_FLATTEN_DEPTH = 256;
const ATTRIBUTED_ENV_FLATTEN_DEPTH = 256;
// Environment states are immutable once published to a branch, so an absent
// binding is just as safe to cache as a present one. Negative lookups are
// especially common while tabling and constraint code probes fresh variables.
const ENV_UNBOUND = Symbol('environment-unbound');
// Runtime terms are structurally immutable: environments hold bindings beside
// them rather than rewriting their argument arrays. Cache only the syntactic
// variable names; binding reachability is still checked against each Env.
const structuralVariableCache = new WeakMap();

export class Term {
  constructor(type, name, args = []) {
    this.type = type;
    this.name = String(name ?? '');
    this.args = args;
  }
  get arity() {
    return this.args.length;
  }
}

// A fixed-length list of fresh variables is represented as one compact
// skeleton and expanded cell-by-cell only when a goal actually inspects it.
// This keeps ordinary logical construction proportional to what the program
// observes instead of eagerly allocating two host objects per list element.
export class CompactListTerm {
  constructor(length, variablePrefix, offset = 0n, state = null) {
    this.type = COMPOUND;
    this.name = '.';
    this._compactLength = BigInt(length);
    this._variablePrefix = variablePrefix;
    this._offset = BigInt(offset);
    this._compactState = state ?? { maxPossiblyBoundIndex: -1n };
    this._args = null;
  }
  get arity() {
    return 2;
  }
  get args() {
    if (this._args == null) {
      const head = variable(`${this._variablePrefix}${this._offset}`);
      head._compactState = this._compactState;
      head._compactIndex = this._offset;
      const tail = this._compactLength === 1n
        ? emptyList()
        : new CompactListTerm(
          this._compactLength - 1n,
          this._variablePrefix,
          this._offset + 1n,
          this._compactState,
        );
      this._args = [head, tail];
    }
    return this._args;
  }
  mayContainVariable(name, env = null) {
    if (String(name).startsWith(this._variablePrefix)) {
      const indexText = String(name).slice(this._variablePrefix.length);
      if (RE_DIGIT_STR.test(indexText)) {
        const index = BigInt(indexText);
        if (index >= this._offset && index < this._offset + this._compactLength) return true;
      }
    }
    // An Env keeps the exact backtrackable set of cells whose current values
    // may reach an external variable. Without one, retain the shared
    // high-water mark as a conservative public-API fallback.
    if (env?.compactListMayReachExternalVariable != null) {
      return env.compactListMayReachExternalVariable(this._compactState, this._offset);
    }
    return this._compactState.maxPossiblyBoundIndex >= this._offset;
  }
}

export const variable = (name) => new Term(VAR, name, EMPTY_ARGS);
export const atom = (name) => new Term(ATOM, name, EMPTY_ARGS);
export const stringTerm = (value) => new Term(STRING, value, EMPTY_ARGS);
export const numberTerm = (value) => new Term(NUMBER, value, EMPTY_ARGS);
export const compound = (name, args = []) => args.length === 0 ? atom(name) : new Term(COMPOUND, name, args);
export const emptyList = () => atom('[]');
export const cons = (head, tail) => compound('.', [head, tail]);
export const compactVariableList = (length, variablePrefix) => {
  const size = BigInt(length);
  return size === 0n ? emptyList() : new CompactListTerm(size, variablePrefix);
};
export const isCompactList = (term) => term instanceof CompactListTerm;
export const compactListLength = (term) => typeof term?._compactLength === 'bigint' ? term._compactLength : null;

export class Env {
  constructor(bindings) {
    this._state = {
      bindings: bindings ? new Map(bindings) : null,
      bindingName: null,
      bindingValue: undefined,
      parent: null,
      depth: 0,
      segmentCount: 0,
      cacheName: null,
      cacheValue: undefined,
      cache: null,
    };
    this._delays = null;
    // Backtracking-safe attributed-variable constraints. Constraints are
    // immutable descriptors shared by cloned environments; the Set/Map index
    // is copied only when a branch adds, removes, or reindexes a constraint.
    this._variableConstraints = null;
    this._variableAnnotations = null;
    // Prolog-visible attributed variables. The outer map is indexed by the
    // current unbound representative name; each representative owns module-
    // scoped attribute terms keyed by functor/arity. Maps are copy-on-write so
    // Env.clone() keeps ordinary Prolog backtracking constant-time.
    this._prologAttributes = null;
    this._attributeHookRunner = null;
    this._pendingAttributeGoals = null;
    // Backtrackable blackboard entries used by Scryer-compatible libraries.
    // Values are logical terms and the map is copy-on-write across Env clones.
    this._backtrackableBlackboard = null;
    this._occursCheckHandler = null;
    this._localVariables = null;
    // Origins carried by variables that temporarily represent compact-list
    // cells. Indexed by logical variable name because callers may reconstruct
    // an equivalent Term object while environments retain name identity.
    this._compactVariableOrigins = null;
    this._compactVariableRisks = null;
  }
  clone() {
    // Most speculative environments are either rejected without a binding or
    // only compare ground terms. Persistent layers make cloning constant-time
    // and keep later writes to either branch isolated. Hot-path layers store a
    // single binding directly; a Map is allocated only when a deep chain is
    // occasionally flattened.
    const clone = Object.create(Env.prototype);
    clone._state = this._state;
    clone._delays = this._delays;
    clone._variableConstraints = this._variableConstraints;
    clone._variableAnnotations = this._variableAnnotations;
    clone._prologAttributes = this._prologAttributes;
    clone._attributeHookRunner = this._attributeHookRunner;
    clone._pendingAttributeGoals = this._pendingAttributeGoals;
    clone._backtrackableBlackboard = this._backtrackableBlackboard;
    clone._occursCheckHandler = this._occursCheckHandler;
    clone._localVariables = this._localVariables;
    clone._compactVariableOrigins = this._compactVariableOrigins;
    clone._compactVariableRisks = this._compactVariableRisks;
    return clone;
  }
  setOccursCheckHandler(handler) {
    this._occursCheckHandler = typeof handler === 'function' ? handler : null;
    return this;
  }
  setAttributeHookRunner(handler) {
    this._attributeHookRunner = typeof handler === 'function' ? handler : null;
    return this;
  }
  _asSolverEnv() {
    return SolverEnv.from(this);
  }
  _isSolverEnv() {
    return false;
  }
  _snapshotForSolverRead() {
    return this.clone();
  }
  adopt(other) {
    if (!(other instanceof Env)) throw new TypeError('Env.adopt expects Env');
    this._state = other._state;
    this._delays = other._delays;
    this._variableConstraints = other._variableConstraints;
    this._variableAnnotations = other._variableAnnotations;
    this._prologAttributes = other._prologAttributes;
    this._pendingAttributeGoals = other._pendingAttributeGoals;
    this._backtrackableBlackboard = other._backtrackableBlackboard;
    // Execution callbacks belong to the Solver driving this Env, not to the
    // logical branch being adopted from an inner attribute-hook call.
    this._localVariables = other._localVariables;
    this._compactVariableOrigins = other._compactVariableOrigins;
    this._compactVariableRisks = other._compactVariableRisks;
    return this;
  }
  compactVariableOrigins(name) {
    return this._compactVariableOrigins?.get(name) ?? null;
  }
  transferCompactVariableOrigins(sourceName, targetName, origins) {
    const next = new Map(this._compactVariableOrigins ?? []);
    if (sourceName !== targetName) next.delete(sourceName);
    next.set(targetName, origins);
    this._compactVariableOrigins = next.size === 0 ? null : next;
  }
  removeCompactVariableOrigins(name) {
    if (this._compactVariableOrigins?.has(name) !== true) return;
    const next = new Map(this._compactVariableOrigins);
    next.delete(name);
    this._compactVariableOrigins = next.size === 0 ? null : next;
  }
  addCompactVariableRisks(origins) {
    if (origins.length === 0) return;
    const next = new Map(this._compactVariableRisks ?? []);
    for (const { state, index } of origins) {
      const current = next.get(state) ?? null;
      let top = current?.top ?? null;
      const removed = current?.removed ?? null;
      while (top != null && removed?.has(top)) top = top.parent;
      // Immediate variable-to-variable handoffs carry the same origin. Avoid
      // stacking duplicate risk entries along that common alias chain.
      if (top?.index === index) continue;
      next.set(state, { top: { index, parent: top }, removed });
    }
    this._compactVariableRisks = next;
  }
  removeCompactVariableRisks(origins) {
    if (origins.length === 0 || this._compactVariableRisks == null) return;
    const next = new Map(this._compactVariableRisks);
    for (const { state, index } of origins) {
      const current = next.get(state);
      if (current == null) continue;
      let top = current.top;
      let removed = current.removed;
      while (top != null && removed?.has(top)) top = top.parent;
      if (top?.index === index) {
        top = top.parent;
        while (top != null && removed?.has(top)) top = top.parent;
      } else {
        // Out-of-order handoffs are uncommon, but remain exact: tombstone
        // every active entry for this origin without rewriting the persistent
        // stack shared by sibling environments.
        let scan = top;
        let changed = false;
        while (scan != null) {
          if (scan.index === index && removed?.has(scan) !== true) {
            if (!changed) removed = new Set(removed ?? []);
            removed.add(scan);
            changed = true;
          }
          scan = scan.parent;
        }
      }
      if (top == null) next.delete(state);
      else next.set(state, { top, removed });
    }
    this._compactVariableRisks = next.size === 0 ? null : next;
  }
  compactListMayReachExternalVariable(state, offset) {
    const current = this._compactVariableRisks?.get(state);
    if (current == null) return false;
    for (let entry = current.top; entry != null; entry = entry.parent) {
      if (current.removed?.has(entry) !== true && entry.index >= offset) return true;
    }
    return false;
  }
  getBacktrackableBlackboard(key) {
    return this._backtrackableBlackboard?.get(key);
  }
  putBacktrackableBlackboard(key, value) {
    const next = new Map(this._backtrackableBlackboard ?? []);
    next.set(key, value);
    this._backtrackableBlackboard = next;
  }
  hasLocalVariables() {
    return this._localVariables != null && this._localVariables.size !== 0;
  }
  isLocalVariable(name) {
    return this._localVariables?.has(name) === true;
  }
  markLocalVariables(names) {
    if (names == null || names.size === 0) return;
    let next = this._localVariables;
    for (const name of names) {
      const root = deref(variable(name), this);
      if (root.type !== VAR || next?.has(root.name)) continue;
      if (next === this._localVariables) next = new Set(this._localVariables ?? []);
      next.add(root.name);
    }
    this._localVariables = next;
  }
  demoteLocalVariable(name) {
    const root = deref(variable(name), this);
    if (root.type !== VAR || this._localVariables?.has(root.name) !== true) return;
    const next = new Set(this._localVariables);
    next.delete(root.name);
    this._localVariables = next.size === 0 ? null : next;
  }
  forgetLocalVariable(name) {
    if (this._localVariables?.has(name) !== true) return;
    const next = new Set(this._localVariables);
    next.delete(name);
    this._localVariables = next.size === 0 ? null : next;
  }
  has(name) {
    return this.get(name) !== undefined;
  }
  get(name) {
    const root = this._state;
    if (root.cacheName === name) {
      return root.cacheValue === ENV_UNBOUND ? undefined : root.cacheValue;
    }
    const cached = root.cache?.get(name);
    if (cached !== undefined) return cached === ENV_UNBOUND ? undefined : cached;
    for (let state = root; state != null; state = state.parent) {
      let value;
      let found = false;
      if (state.bindingName === name) {
        value = state.bindingValue;
        found = true;
      } else if (state.bindings?.has(name)) {
        value = state.bindings.get(name);
        found = true;
      }
      if (found) {
        if (root.depth >= 4) {
          if (root.cacheName == null) {
            root.cacheName = name;
            root.cacheValue = value;
          } else {
            (root.cache ??= new Map([[root.cacheName, root.cacheValue]])).set(name, value);
          }
        }
        return value;
      }
    }
    if (root.depth >= 4) {
      if (root.cacheName == null) {
        root.cacheName = name;
        root.cacheValue = ENV_UNBOUND;
      } else {
        (root.cache ??= new Map([[root.cacheName, root.cacheValue]])).set(name, ENV_UNBOUND);
      }
    }
    return undefined;
  }
  *_bindingEntries() {
    const seen = new Set();
    for (let state = this._state; state != null; state = state.parent) {
      if (state.bindingName != null && !seen.has(state.bindingName)) {
        seen.add(state.bindingName);
        yield [state.bindingName, state.bindingValue];
      }
      if (state.bindings) {
        for (const [name, value] of state.bindings) {
          if (seen.has(name)) continue;
          seen.add(name);
          yield [name, value];
        }
      }
    }
  }
  compactForDeepContinuation(segmentLimit = 16) {
    if ((this._state.segmentCount ?? 0) < segmentLimit) return false;
    const flattened = new Map();
    for (let state = this._state; state != null; state = state.parent) {
      if (state.bindingName != null && !flattened.has(state.bindingName)) {
        flattened.set(state.bindingName, state.bindingValue);
      }
      if (state.bindings) {
        for (const [key, value] of state.bindings) {
          if (!flattened.has(key)) flattened.set(key, value);
        }
      }
    }
    this._state = {
      bindings: flattened,
      bindingName: null,
      bindingValue: undefined,
      parent: null,
      depth: 0,
      segmentCount: 0,
      cacheName: null,
      cacheValue: undefined,
      cache: null,
    };
    return true;
  }
  bind(name, term) {
    const flattenDepth = this._prologAttributes == null
      ? ENV_FLATTEN_DEPTH
      : ATTRIBUTED_ENV_FLATTEN_DEPTH;
    if (this._state.depth >= flattenDepth) {
      // Compact only the newest single-binding segment. Older compacted
      // segments remain linked as parents, so deep deterministic recursion
      // never recopies its complete binding history at every threshold.
      const segment = new Map([[name, term]]);
      let state = this._state;
      while (state != null && state.bindings == null) {
        if (state.bindingName != null && !segment.has(state.bindingName)) {
          segment.set(state.bindingName, state.bindingValue);
        }
        state = state.parent;
      }
      this._state = {
        bindings: segment,
        bindingName: null,
        bindingValue: undefined,
        parent: state,
        depth: 0,
        segmentCount: (state?.segmentCount ?? 0) + 1,
        cacheName: null,
        cacheValue: undefined,
        cache: null,
      };
      return;
    }
    this._state = {
      bindings: null,
      bindingName: name,
      bindingValue: term,
      parent: this._state,
      depth: this._state.depth + 1,
      segmentCount: this._state.segmentCount ?? 0,
      cacheName: null,
      cacheValue: undefined,
      cache: null,
    };
  }
  delay(name, goal, module = 'user') {
    const delays = new Map(this._delays ?? []);
    delays.set(name, [...(delays.get(name) ?? []), { goal, module }]);
    this._delays = delays;
  }
  delayedVariableNames() {
    if (this._delays == null || this._delays.size === 0) return [];
    const names = [];
    const seen = new Set();
    for (const name of this._delays.keys()) {
      const root = deref(variable(name), this);
      if (root.type !== VAR || seen.has(root.name)) continue;
      seen.add(root.name);
      names.push(root.name);
    }
    return names;
  }
  delayedGoals(name) {
    const root = deref(variable(name), this);
    if (root.type !== VAR || this._delays == null) return [];
    const result = [];
    for (const [source, goals] of this._delays) {
      const current = deref(variable(source), this);
      if (current.type === VAR && current.name === root.name) result.push(...goals);
    }
    return result;
  }
  takeReadyDelays() {
    if (this._delays == null || this._delays.size === 0) return [];
    const ready = [];
    let remaining = this._delays;
    for (const [name, delays] of this._delays) {
      if (deref(variable(name), this).type === VAR) continue;
      if (remaining === this._delays) remaining = new Map(this._delays);
      remaining.delete(name);
      ready.push(...delays);
    }
    if (ready.length > 0) this._delays = remaining;
    return ready;
  }
  _attributeRootName(name) {
    const root = deref(variable(name), this);
    return root.type === VAR ? root.name : null;
  }
  _attributeModulesForRoot(name) {
    const root = this._attributeRootName(name);
    return root == null ? null : (this._prologAttributes?.get(root) ?? null);
  }
  prologAttributes(name, module = null) {
    const modules = this._attributeModulesForRoot(name);
    if (modules == null) return [];
    if (module != null) return [...(modules.get(module)?.values() ?? [])];
    const result = [];
    for (const [owner, attrs] of modules) {
      for (const attribute of attrs.values()) result.push({ module: owner, attribute });
    }
    return result;
  }
  prologAttributeModules(name) {
    const modules = this._attributeModulesForRoot(name);
    return modules == null ? [] : [...modules.keys()];
  }
  getPrologAttribute(name, module, functor, arity) {
    const modules = this._attributeModulesForRoot(name);
    return modules?.get(module)?.get(`${functor}/${arity}`) ?? null;
  }
  putPrologAttribute(name, module, attribute) {
    const root = this._attributeRootName(name);
    if (root == null) return false;
    const signature = `${attribute.name}/${attribute.arity}`;
    const outer = new Map(this._prologAttributes ?? []);
    const modules = new Map(outer.get(root) ?? []);
    const attrs = new Map(modules.get(module) ?? []);
    attrs.set(signature, attribute);
    modules.set(module, attrs);
    outer.set(root, modules);
    this._prologAttributes = outer;
    return true;
  }
  deletePrologAttribute(name, module, functor, arity = null) {
    const root = this._attributeRootName(name);
    if (root == null) return false;
    const existingModules = this._prologAttributes?.get(root);
    const existingAttrs = existingModules?.get(module);
    if (existingAttrs == null) return false;
    const attrs = new Map(existingAttrs);
    let deleted = false;
    if (arity == null) {
      for (const key of [...attrs.keys()]) {
        if (key.startsWith(`${functor}/`)) { attrs.delete(key); deleted = true; }
      }
    } else {
      deleted = attrs.delete(`${functor}/${arity}`);
    }
    if (!deleted) return false;
    const modules = new Map(existingModules);
    if (attrs.size === 0) modules.delete(module); else modules.set(module, attrs);
    const outer = new Map(this._prologAttributes);
    if (modules.size === 0) outer.delete(root); else outer.set(root, modules);
    this._prologAttributes = outer.size === 0 ? null : outer;
    return true;
  }
  hasPrologAttributes(name) {
    const modules = this._attributeModulesForRoot(name);
    if (modules == null) return false;
    for (const attrs of modules.values()) if (attrs.size !== 0) return true;
    return false;
  }
  attributedVariableNames() {
    if (this._prologAttributes == null) return [];
    const names = [];
    const seen = new Set();
    for (const name of this._prologAttributes.keys()) {
      const root = deref(variable(name), this);
      if (root.type !== VAR || seen.has(root.name)) continue;
      if (!this.hasPrologAttributes(root.name)) continue;
      seen.add(root.name);
      names.push(root.name);
    }
    return names;
  }
  enqueueAttributeGoals(goals) {
    if (goals == null || goals.length === 0) return;
    this._pendingAttributeGoals = [...(this._pendingAttributeGoals ?? []), ...goals];
  }
  takePendingAttributeGoals() {
    if (this._pendingAttributeGoals == null || this._pendingAttributeGoals.length === 0) return [];
    const goals = this._pendingAttributeGoals;
    this._pendingAttributeGoals = null;
    return goals;
  }
  _targetHasOwnerModule(name, module) {
    return this._attributeModulesForRoot(name)?.has(module) === true;
  }
  preparePrologAttributeUnification(variableTerm, otherTerm) {
    if (this._prologAttributes == null || variableTerm?.type !== VAR) return true;
    const sourceRoot = deref(variableTerm, this);
    if (sourceRoot.type !== VAR) return true;
    const modules = this.prologAttributeModules(sourceRoot.name);
    if (modules.length === 0) return true;
    const other = deref(otherTerm, this);
    if (other.type === VAR) {
      if (other.name === sourceRoot.name) return true;
      // Aliasing an attributed variable with a plain variable is just a
      // representative change. No user-level hook is needed; final aliasing
      // moves the attributes to the surviving representative.
      const hooks = modules.filter((module) => this._targetHasOwnerModule(other.name, module));
      for (const module of hooks) {
        if (this._attributeHookRunner && !this._attributeHookRunner(module, sourceRoot, other, this)) return false;
      }
      return true;
    }
    for (const module of modules) {
      if (this._attributeHookRunner && !this._attributeHookRunner(module, sourceRoot, other, this)) return false;
    }
    return true;
  }
  finalizePrologAttributeAlias(sourceName, targetName) {
    if (this._prologAttributes == null || sourceName === targetName) return;
    const source = this._prologAttributes.get(sourceName);
    if (source == null) return;
    const outer = new Map(this._prologAttributes);
    const target = new Map(outer.get(targetName) ?? []);
    for (const [module, sourceAttrs] of source) {
      const attrs = new Map(target.get(module) ?? []);
      for (const [signature, attribute] of sourceAttrs) {
        if (!attrs.has(signature)) attrs.set(signature, attribute);
      }
      target.set(module, attrs);
    }
    outer.delete(sourceName);
    outer.set(targetName, target);
    this._prologAttributes = outer;
  }
  dropPrologAttributes(name) {
    if (this._prologAttributes == null) return;
    const outer = new Map(this._prologAttributes);
    outer.delete(name);
    this._prologAttributes = outer.size === 0 ? null : outer;
  }
  addVariableConstraint(constraint) {
    if (constraint == null || typeof constraint.variables !== 'function' ||
        typeof constraint.status !== 'function') {
      throw new TypeError('variable constraint requires variables(env) and status(env)');
    }
    this._setNormalizedVariableConstraints([...(this._variableConstraints ?? []), constraint]);
  }
  _setNormalizedVariableConstraints(constraints) {
    // Descriptors may define logical subsumption. Keep the strongest pending
    // constraints so equivalent, symmetric, or weaker residual goals do not
    // accumulate, while unrelated descriptor kinds remain untouched.
    const normalized = [];
    candidateLoop:
    for (const candidate of constraints) {
      for (const existing of normalized) {
        if (existing === candidate || existing.subsumes?.(candidate, this) === true) continue candidateLoop;
      }
      for (let index = normalized.length - 1; index >= 0; index--) {
        if (candidate.subsumes?.(normalized[index], this) === true) normalized.splice(index, 1);
      }
      normalized.push(candidate);
    }
    this._variableConstraints = normalized.length === 0 ? null : new Set(normalized);
    this._reindexVariableConstraints();
  }
  variableConstraints(kind = null) {
    const constraints = [...(this._variableConstraints ?? [])];
    return kind == null ? constraints : constraints.filter((constraint) => constraint.kind === kind);
  }
  variableAnnotations(name) {
    const root = deref(variable(name), this);
    if (root.type !== VAR) return [];
    return [...(this._variableAnnotations?.get(root.name) ?? [])];
  }
  validateVariableConstraints() {
    if (this._variableConstraints == null || this._variableConstraints.size === 0) return true;
    const pending = new Set();
    for (const constraint of this._variableConstraints) {
      const status = constraint.status(this);
      if (status === 'violated') return false;
      if (status !== 'entailed') pending.add(constraint);
    }
    this._setNormalizedVariableConstraints(pending);
    return true;
  }
  _reindexVariableConstraints() {
    if (this._variableConstraints == null || this._variableConstraints.size === 0) {
      this._variableAnnotations = null;
      return;
    }
    const annotations = new Map();
    for (const constraint of this._variableConstraints) {
      for (const name of constraint.variables(this)) {
        const root = deref(variable(name), this);
        if (root.type !== VAR) continue;
        const set = annotations.get(root.name) ?? new Set();
        set.add(constraint);
        annotations.set(root.name, set);
      }
    }
    this._variableAnnotations = annotations.size === 0 ? null : annotations;
  }
}


class SolverBindingStore {
  constructor(bindings) {
    this.slots = new Map();
    this.names = [];
    this.values = [];
    this.baseValues = [];
    this.slotLastTrail = [];
    this.freeSlots = [];
    this.trailSlots = [];
    this.trailOldValues = [];
    this.trailNewValues = [];
    this.trailPreviousForSlot = [];
    if (bindings != null) {
      for (const [name, value] of bindings) {
        const slot = this.names.length;
        this.slots.set(name, slot);
        this.names.push(name);
        this.values.push(value);
        this.baseValues.push(value);
        this.slotLastTrail.push(-1);
      }
    }
  }

  mark() {
    return this.trailSlots.length;
  }

  rollback(mark) {
    if (mark > this.trailSlots.length) {
      throw new Error('stale solver binding mark');
    }
    while (this.trailSlots.length > mark) {
      const previousForSlot = this.trailPreviousForSlot.pop();
      this.trailNewValues.pop();
      const oldValue = this.trailOldValues.pop();
      const slot = this.trailSlots.pop();
      this.slotLastTrail[slot] = previousForSlot;
      if (oldValue === ENV_UNBOUND) {
        this.slots.delete(this.names[slot]);
        this.values[slot] = ENV_UNBOUND;
        this.baseValues[slot] = ENV_UNBOUND;
        this.names[slot] = null;
        this.freeSlots.push(slot);
      } else {
        this.values[slot] = oldValue;
      }
    }
  }

  bind(name, value) {
    let slot = this.slots.get(name);
    const created = slot === undefined;
    if (created) {
      slot = this.freeSlots.length === 0 ? this.values.length : this.freeSlots.pop();
      this.slots.set(name, slot);
      this.names[slot] = name;
      this.values[slot] = ENV_UNBOUND;
      this.baseValues[slot] = ENV_UNBOUND;
      this.slotLastTrail[slot] = -1;
    }
    const entry = this.trailSlots.length;
    this.trailSlots.push(slot);
    this.trailOldValues.push(this.values[slot]);
    this.trailNewValues.push(value);
    this.trailPreviousForSlot.push(this.slotLastTrail[slot] ?? -1);
    this.slotLastTrail[slot] = entry;
    this.values[slot] = value;
  }

  getAtMark(name, mark) {
    if (mark > this.trailSlots.length) throw new Error('stale solver binding mark');
    const slot = this.slots.get(name);
    if (slot === undefined) return undefined;
    let entry = this.slotLastTrail[slot] ?? -1;
    while (entry >= mark) entry = this.trailPreviousForSlot[entry] ?? -1;
    const value = entry >= 0 ? this.trailNewValues[entry] : this.baseValues[slot];
    return value === ENV_UNBOUND ? undefined : value;
  }
}

function copyEnvBranchState(source, target) {
  target._delays = source._delays;
  target._variableConstraints = source._variableConstraints;
  target._variableAnnotations = source._variableAnnotations;
  target._prologAttributes = source._prologAttributes;
  target._attributeHookRunner = source._attributeHookRunner;
  target._pendingAttributeGoals = source._pendingAttributeGoals;
  target._backtrackableBlackboard = source._backtrackableBlackboard;
  target._occursCheckHandler = source._occursCheckHandler;
  target._localVariables = source._localVariables;
  target._compactVariableOrigins = source._compactVariableOrigins;
  target._compactVariableRisks = source._compactVariableRisks;
  return target;
}

class SolverEnvReadView {
  constructor(source) {
    this._solverBindings = source._solverBindings;
    this._solverBindingMark = source._solverBindingMark;
    this._localVariables = source._localVariables;
  }
  get(name) {
    return this._solverBindings.getAtMark(name, this._solverBindingMark);
  }
  has(name) {
    return this.get(name) !== undefined;
  }
  isLocalVariable(name) {
    return this._localVariables?.has(name) === true;
  }
}

// SolverEnv replaces persistent binding layers with one solver-owned mutable
// slot store and a linear trail. Clones are just trail marks plus the existing
// copy-on-write logical side stores. The solver explores these marks in depth-
// first order, so rollback can discard unreachable branch history immediately.
// Public Env remains persistent and is used for stable API snapshots.
class SolverEnv extends Env {
  constructor() {
    super();
    this._solverBindings = new SolverBindingStore();
    this._solverBindingMark = 0;
    this._state = null;
  }

  static from(env) {
    if (env instanceof SolverEnv) return env;
    const solverEnv = Object.create(SolverEnv.prototype);
    solverEnv._state = null;
    solverEnv._solverBindings = new SolverBindingStore(env?._bindingEntries?.() ?? []);
    solverEnv._solverBindingMark = 0;
    copyEnvBranchState(env ?? new Env(), solverEnv);
    return solverEnv;
  }

  _asSolverEnv() {
    return this;
  }

  _isSolverEnv() {
    return true;
  }

  _snapshotForSolverRead() {
    return new SolverEnvReadView(this);
  }

  _activateBindings() {
    if (this._solverBindingMark !== this._solverBindings.trailSlots.length) {
      this._solverBindings.rollback(this._solverBindingMark);
    }
  }

  clone() {
    this._activateBindings();
    const clone = Object.create(SolverEnv.prototype);
    clone._state = null;
    clone._solverBindings = this._solverBindings;
    clone._solverBindingMark = this._solverBindingMark;
    return copyEnvBranchState(this, clone);
  }

  adopt(other) {
    if (!(other instanceof Env)) throw new TypeError('Env.adopt expects Env');
    if (other instanceof SolverEnv && other._solverBindings === this._solverBindings) {
      other._activateBindings();
      this._solverBindingMark = other._solverBindingMark;
    } else {
      const replacement = SolverEnv.from(other);
      this._solverBindings = replacement._solverBindings;
      this._solverBindingMark = replacement._solverBindingMark;
    }
    copyEnvBranchState(other, this);
    return this;
  }

  get(name) {
    if (this._solverBindingMark !== this._solverBindings.trailSlots.length) {
      this._solverBindings.rollback(this._solverBindingMark);
    }
    const slot = this._solverBindings.slots.get(name);
    if (slot === undefined) return undefined;
    const value = this._solverBindings.values[slot];
    return value === ENV_UNBOUND ? undefined : value;
  }

  *_bindingEntries() {
    this._activateBindings();
    for (const [name, slot] of this._solverBindings.slots) {
      const value = this._solverBindings.values[slot];
      if (value !== ENV_UNBOUND) yield [name, value];
    }
  }

  bind(name, term) {
    if (this._solverBindingMark !== this._solverBindings.trailSlots.length) {
      this._solverBindings.rollback(this._solverBindingMark);
    }
    this._solverBindings.bind(name, term);
    this._solverBindingMark = this._solverBindings.trailSlots.length;
  }

  compactForDeepContinuation() {
    return false;
  }

  _toPersistentEnv() {
    const stable = new Env(this._bindingEntries());
    copyEnvBranchState(this, stable);
    return stable;
  }
}

export function deref(term, env) {
  // Follow variable bindings until a non-variable term is reached. The seen set
  // protects readback from accidental cycles in partially constructed terms.
  let current = term;
  let seen = null;
  while (current?.type === VAR) {
    // A live compiler-proven DCG local is the current unbound representative.
    // No older Env layer can contain a binding for it.
    if (env?.isLocalVariable?.(current.name) === true) break;
    const next = env?.get(current.name);
    if (next === undefined) break;
    if (seen?.has(current.name)) break;
    (seen ??= new Set()).add(current.name);
    current = next;
  }
  return current;
}

export function isScalar(term) {
  return term && (term.type === ATOM || term.type === STRING || term.type === NUMBER);
}

export function isEmptyList(term) {
  return term?.type === ATOM && term.name === '[]';
}

export function isCons(term) {
  return term?.type === COMPOUND && term.name === '.' && term.arity === 2;
}

export function isConjunction(term) {
  return term?.type === COMPOUND && term.name === ',' && term.arity === 2;
}

function structuralVariableNames(term) {
  if (isScalar(term)) return EMPTY_ARGS;
  if (term?.type === VAR) return [term.name];
  if (term?.type !== COMPOUND) return EMPTY_ARGS;

  if (!isCompactList(term) && term.arity === 2) {
    const left = term.args[0];
    const right = term.args[1];
    const leftSimple = left?.type === VAR || isScalar(left);
    const rightSimple = right?.type === VAR || isScalar(right);
    if (leftSimple && rightSimple) {
      if (left?.type === VAR) {
        if (right?.type === VAR) return left.name === right.name ? [left.name] : [left.name, right.name];
        return [left.name];
      }
      if (right?.type === VAR) return [right.name];
      return EMPTY_ARGS;
    }
  }

  const cached = structuralVariableCache.get(term);
  if (cached !== undefined) return cached;

  const names = new Set();
  const stack = [term];
  const seenTerms = new Set();
  while (stack.length) {
    const current = stack.pop();
    if (current?.type === VAR) {
      names.add(current.name);
      continue;
    }
    if (isCompactList(current)) return null;
    if (current?.type !== COMPOUND || seenTerms.has(current)) continue;
    seenTerms.add(current);
    for (let i = 0; i < current.arity; i++) stack.push(current.args[i]);
  }

  const result = names.size === 0 ? EMPTY_ARGS : [...names];
  structuralVariableCache.set(term, result);
  return result;
}

function occursUncached(variableName, term, env) {
  // Walk bindings and compound arguments iteratively so the occurs check also
  // remains safe for very deep terms. The visited sets make this defensive
  // against cycles introduced through the public Env API.
  if (isScalar(term)) return false;
  const stack = [term];
  const seenVariables = new Set();
  const seenTerms = new Set();

  while (stack.length) {
    const current = stack.pop();
    if (current?.type === VAR) {
      if (current.name === variableName) return true;
      if (seenVariables.has(current.name)) continue;
      seenVariables.add(current.name);
      const binding = env?.get(current.name);
      if (binding !== undefined) stack.push(binding);
      continue;
    }
    if (isCompactList(current) && !current.mayContainVariable(variableName, env)) continue;
    if (current?.type !== COMPOUND || seenTerms.has(current)) continue;
    seenTerms.add(current);
    for (let i = 0; i < current.arity; i++) stack.push(current.args[i]);
  }

  return false;
}

function occurs(variableName, term, env) {
  if (isScalar(term)) return false;
  const initial = structuralVariableNames(term);
  if (initial == null) return occursUncached(variableName, term, env);
  if (initial.length === 0) return false;

  // Lists, wrappers, and arithmetic expressions commonly contain one logical
  // variable. Follow that unary binding chain without allocating a work queue
  // and hash set for every occurs check. Fall back to the general graph walk
  // as soon as a binding fans out.
  if (initial.length === 1) {
    let name = initial[0];
    const seenSmall = [];
    let seenLarge = null;
    while (true) {
      if (name === variableName) return true;
      let alreadySeen = seenLarge?.has(name) === true;
      if (seenLarge == null) {
        for (let index = 0; index < seenSmall.length; index++) {
          if (seenSmall[index] === name) { alreadySeen = true; break; }
        }
      }
      if (alreadySeen) return false;
      if (seenLarge != null) seenLarge.add(name);
      else {
        seenSmall.push(name);
        if (seenSmall.length === 8) seenLarge = new Set(seenSmall);
      }
      const binding = env?.get(name);
      if (binding === undefined) return false;
      const names = structuralVariableNames(binding);
      if (names == null || names.length > 1) return occursUncached(variableName, term, env);
      if (names.length === 0) return false;
      name = names[0];
    }
  }

  const pending = initial.slice();
  const seenSmall = [];
  let seenLarge = null;
  for (let index = 0; index < pending.length; index++) {
    const name = pending[index];
    if (name === variableName) return true;
    let alreadySeen = false;
    if (seenLarge != null) alreadySeen = seenLarge.has(name);
    else for (let j = 0; j < seenSmall.length; j++) { if (seenSmall[j] === name) { alreadySeen = true; break; } }
    if (alreadySeen) continue;
    if (seenLarge != null) seenLarge.add(name);
    else { seenSmall.push(name); if (seenSmall.length === 8) seenLarge = new Set(seenSmall); }
    const binding = env?.get(name);
    if (binding === undefined) continue;
    const names = structuralVariableNames(binding);
    if (names == null) return occursUncached(variableName, term, env);
    for (const child of names) pending.push(child);
  }
  return false;
}

export function unify(left, right, env, options = {}) {
  // Iterative unification avoids deep JavaScript recursion on long lists or
  // deeply nested compounds. The occurs check gives EyeProlog finite-tree
  // unification: a variable cannot be bound to a term containing itself.
  // Bindings are written into the supplied Env.
  const occursCheckHandler = options.occursCheck === 'fail' ? null : env?._occursCheckHandler;
  const runAttributeHooks = options.skipAttributeHooks !== true;
  // Callers may provide a proof that selected variables cannot occur in the
  // term they are about to receive.  Source-level first-use analysis and a few
  // construction fast paths share this internal proof; ordinary unification
  // remains fully occurs-checked.
  const knownNonoccurringVariables = options.knownNonoccurringVariables ?? null;
  const stack = [left, right];
  while (stack.length) {
    let b = stack.pop();
    let a = stack.pop();
    a = deref(a, env);
    b = deref(b, env);

    if (a.type === VAR && b.type === VAR && a.name === b.name) continue;
    if (a.type === VAR && b.type === VAR) {
      if (runAttributeHooks && env?._prologAttributes != null) {
        if (!env.preparePrologAttributeUnification(a, b)) return false;
        a = deref(a, env);
        b = deref(b, env);
        if (a.type !== VAR || b.type !== VAR || a.name === b.name) {
          stack.push(a, b);
          continue;
        }
      }
      // For a compiler-generated DCG state handed directly to another
      // nonterminal, keep the local caller variable as representative. Ordinary
      // aliases retain the established direction and observable conventions.
      const aLocalDcg = env?.isLocalVariable(a.name) === true &&
        a.name.startsWith('\u0000dcg') && b.name.startsWith('\u0000dcg');
      if (aLocalDcg) {
        transferCompactVariableOrigins(b, a, env);
        env?.finalizePrologAttributeAlias?.(b.name, a.name);
        env.bind(b.name, a);
      } else {
        transferCompactVariableOrigins(a, b, env);
        env?.finalizePrologAttributeAlias?.(a.name, b.name);
        env.bind(a.name, b);
      }
      continue;
    }
    if (a.type === VAR) {
      const aLocal = env?.isLocalVariable(a.name) === true;
      if (!aLocal && !knownNonoccurringVariables?.has(a.name) && occurs(a.name, b, env)) {
        occursCheckHandler?.(a, b, env);
        return false;
      }
      if (runAttributeHooks && env?._prologAttributes != null && env.hasPrologAttributes(a.name)) {
        if (!env.preparePrologAttributeUnification(a, b)) return false;
        a = deref(a, env);
        b = deref(b, env);
        if (a.type !== VAR) { stack.push(a, b); continue; }
      }
      markCompactVariableBound(a, b, env);
      env?.dropPrologAttributes?.(a.name);
      env.bind(a.name, b);
      if (aLocal) env.forgetLocalVariable(a.name);
      continue;
    }
    if (b.type === VAR) {
      const bLocal = env?.isLocalVariable(b.name) === true;
      if (!bLocal && !knownNonoccurringVariables?.has(b.name) && occurs(b.name, a, env)) {
        occursCheckHandler?.(b, a, env);
        return false;
      }
      if (runAttributeHooks && env?._prologAttributes != null && env.hasPrologAttributes(b.name)) {
        if (!env.preparePrologAttributeUnification(b, a)) return false;
        b = deref(b, env);
        a = deref(a, env);
        if (b.type !== VAR) { stack.push(a, b); continue; }
      }
      markCompactVariableBound(b, a, env);
      env?.dropPrologAttributes?.(b.name);
      env.bind(b.name, a);
      if (bLocal) env.forgetLocalVariable(b.name);
      continue;
    }

    if (a.type !== b.type) {
      return false;
    }

    if (isScalar(a)) {
      if (a.type === NUMBER ? !sameNumberValue(a.name, b.name) : a.name !== b.name) return false;
      continue;
    }

    if (a.type === COMPOUND) {
      if (a.name !== b.name || a.arity !== b.arity) return false;
      for (let i = a.arity - 1; i >= 0; i--) stack.push(a.args[i], b.args[i]);
      continue;
    }

    return false;
  }
  if (options.skipVariableConstraints !== true && env?._variableConstraints != null && !env.validateVariableConstraints()) return false;
  return true;
}

function compactVariableOrigins(term, env) {
  const remembered = term?.type === VAR ? env?.compactVariableOrigins(term.name) : null;
  const origins = remembered == null ? [] : [...remembered];
  if (term?._compactState != null && term._compactIndex != null &&
      !origins.some(({ state, index }) => state === term._compactState && index === term._compactIndex)) {
    origins.push({ state: term._compactState, index: term._compactIndex });
  }
  return origins;
}

function transferCompactVariableOrigins(source, target, env) {
  const sourceOrigins = compactVariableOrigins(source, env);
  if (sourceOrigins.length === 0 || target?.type !== VAR) return;
  const targetOrigins = compactVariableOrigins(target, env);
  for (const origin of sourceOrigins) {
    if (!targetOrigins.some(({ state, index }) => state === origin.state && index === origin.index)) {
      targetOrigins.push(origin);
    }
  }
  env?.addCompactVariableRisks(sourceOrigins);
  env?.transferCompactVariableOrigins(source.name, target.name, targetOrigins);
}

function markCompactVariableBound(term, value, env) {
  const origins = compactVariableOrigins(term, env);
  if (origins.length === 0) return;
  // A compact cell commonly passes through a fresh clause variable before it
  // receives its actual value. Carry the provenance along that alias. Only a
  // non-scalar value can make an unrelated logical variable reachable from
  // the compact list, so ground atoms and numbers need not poison the whole
  // suffix for subsequent finite-tree occurs checks.
  if (value?.type === VAR) {
    transferCompactVariableOrigins(term, value, env);
    return;
  }
  if (isScalar(value)) {
    env?.removeCompactVariableRisks(origins);
    env?.removeCompactVariableOrigins(term.name);
    return;
  }
  env?.addCompactVariableRisks(origins);
  env?.removeCompactVariableOrigins(term.name);
  for (const { state, index } of origins) {
    if (index > state.maxPossiblyBoundIndex) state.maxPossiblyBoundIndex = index;
  }
}

export function cloneTerm(term) {
  if (term.type === VAR) return variable(term.name);
  const cloned = term.type === COMPOUND && term.arity === 0
    ? atom(term.name)
    : new Term(term.type, term.name, term.args.map(cloneTerm));
  if (term.module != null) cloned.module = term.module;
  return cloned;
}

export function freshTerm(term, suffix, variables = new Map()) {
  if (term.type === VAR) {
    let fresh = variables.get(term.name);
    if (fresh == null) {
      fresh = variable(`${term.name}#${suffix}`);
      variables.set(term.name, fresh);
    }
    return fresh;
  }
  let fresh;
  if (term.type === COMPOUND && term.arity === 0) {
    fresh = atom(term.name);
  } else {
    const args = new Array(term.args.length);
    for (let index = 0; index < args.length; index++) {
      args[index] = freshTerm(term.args[index], suffix, variables);
    }
    fresh = new Term(term.type, term.name, args);
  }
  if (term.module != null) fresh.module = term.module;
  return fresh;
}

export function copyResolved(term, env) {
  const makeCopy = (resolved) => {
    if (resolved.type === VAR) return variable(resolved.name);
    const copied = resolved.type === COMPOUND && resolved.arity === 0
      ? atom(resolved.name)
      : new Term(resolved.type, resolved.name, new Array(resolved.args.length));
    if (resolved.module != null) copied.module = resolved.module;
    return copied;
  };

  const resolved = deref(term, env);
  const copied = makeCopy(resolved);
  if (resolved.type === VAR || resolved.args.length === 0) return copied;

  // Deep lists and machine-state terms can contain thousands of nested cells.
  // Copy them iteratively so readback never consumes the JavaScript call stack.
  // Keep a source-to-copy map as well, both to preserve shared subterms and to
  // terminate on rational trees when occurs_check is disabled.
  const copies = new Map([[resolved, copied]]);
  const pending = [{ source: resolved, target: copied }];
  while (pending.length > 0) {
    const { source, target } = pending.pop();
    for (let index = 0; index < source.args.length; index++) {
      const childSource = deref(source.args[index], env);
      let childCopy = copies.get(childSource);
      if (childCopy == null) {
        childCopy = makeCopy(childSource);
        if (childSource.type !== VAR && childSource.args.length > 0) {
          copies.set(childSource, childCopy);
          pending.push({ source: childSource, target: childCopy });
        }
      }
      target.args[index] = childCopy;
    }
  }
  return copied;
}

export function termIsGround(term, env = new Env()) {
  // Defer the cycle-guard Set until we encounter a compound term, since
  // the overwhelming majority of ground checks are on acyclic clause data.
  const pending = [term];
  let seen = null;
  while (pending.length > 0) {
    const resolved = deref(pending.pop(), env);
    if (resolved.type === VAR) return false;
    const arity = resolved.args.length;
    if (arity === 0) continue;
    if (seen == null) seen = new Set();
    if (seen.has(resolved)) continue;
    seen.add(resolved);
    // Visit leftmost arguments first. Lists and other recursive structures
    // commonly carry their first unbound variable there, allowing a
    // non-ground check to finish without walking the complete tail.
    for (let index = arity - 1; index >= 0; index--) {
      pending.push(resolved.args[index]);
    }
  }
  return true;
}

const graphicAtomChars = new Set('!#$&*+-/<=>@^~\\'.split(''));

const RE_LOWER_IDENT = /^[a-z][A-Za-z0-9_]*$/;
const RE_UPPER_IDENT = /^(?:_|[A-Z_][A-Za-z0-9_]*)$/;
const RE_LEGACY_VAR = /^\?(?:[A-Za-z_][A-Za-z0-9_]*)?$/;
const RE_FLOAT = /^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$/;
const RE_DIGIT_STR = /^\d+$/;
const RE_SANITIZE_VAR = /[^A-Za-z0-9_]/g;
const RE_UPPER_START = /^[A-Z_]/;
function atomNeedsQuotes(name) {
  if (!name) return true;
  if (name === '[]' || name === '{}') return false;
  if (name === '\\+' || name === '+' || name === '-' || name === '\\') return true;
  if (RE_LOWER_IDENT.test(name)) return false;
  for (const ch of name) if (!graphicAtomChars.has(ch)) return true;
  return false;
}

// Shared "wrap in a quote character, escaping a fixed table of characters"
// idiom for quoted atoms and double-quoted strings. The two forms use
// different escaping conventions for their own delimiter (atoms double it,
// per ISO quoted-atom syntax; strings backslash-escape it), so that part
// stays an explicit parameter rather than folded into one shared table.
function escapeQuoted(text, quoteChar, quoteEscape, table) {
  let out = quoteChar;
  for (const ch of text) {
    if (ch === quoteChar) out += quoteEscape;
    else if (table[ch] !== undefined) out += table[ch];
    else out += ch;
  }
  return out + quoteChar;
}

const ATOM_ESCAPE_TABLE = { '\\': '\\\\', '\n': '\\n', '\t': '\\t' };

function quoteAtom(name) {
  return escapeQuoted(name, "'", "''", ATOM_ESCAPE_TABLE);
}

function writeAtom(name) {
  return atomNeedsQuotes(name) ? quoteAtom(name) : name;
}

function legacyVariableToIso(name) {
  if (name === '?') return '_';
  const tail = name.slice(1);
  if (!tail) return '_';
  if (tail[0] === '_') return tail;
  return tail[0].toUpperCase() + tail.slice(1);
}

function writeVariable(name) {
  name = String(name ?? '');
  if (RE_LEGACY_VAR.test(name)) return legacyVariableToIso(name);
  if (RE_UPPER_IDENT.test(name)) return name;
  const sanitized = name.replace(RE_SANITIZE_VAR, '_');
  if (!sanitized) return '_';
  return RE_UPPER_START.test(sanitized) ? sanitized : `_${sanitized}`;
}

const STRING_ESCAPE_TABLE = {
  '\\': '\\\\', '\x07': '\\a', '\b': '\\b', '\r': '\\r',
  '\f': '\\f', '\t': '\\t', '\n': '\\n', '\v': '\\v',
};

function writeString(value, quoteStrings) {
  if (!quoteStrings) return value;
  return escapeQuoted(value, '"', '\\"', STRING_ESCAPE_TABLE);
}

function quotedListSplice(term, env, doubleQuotes) {
  if (doubleQuotes !== 'chars' && doubleQuotes !== 'codes') return null;
  const characters = [];
  let cursor = term;
  while (true) {
    cursor = deref(cursor, env);
    if (isEmptyList(cursor)) {
      return characters.length === 0 ? null : { text: characters.join(''), tail: null };
    }
    if (!isCons(cursor)) {
      return characters.length === 0 ? null : { text: characters.join(''), tail: cursor };
    }
    const item = deref(cursor.args[0], env);
    if (doubleQuotes === 'chars') {
      if (item.type !== ATOM || Array.from(item.name).length !== 1) return null;
      characters.push(item.name);
    } else {
      if (item.type !== NUMBER || !RE_DIGIT_STR.test(item.name)) return null;
      const code = BigInt(item.name);
      if (code < 0n || code > 0x10ffffn || (code >= 0xd800n && code <= 0xdfffn)) return null;
      characters.push(String.fromCodePoint(Number(code)));
    }
    cursor = cursor.args[1];
  }
}

function writeList(term, env, options) {
  const quotedSplice = quotedListSplice(term, env, options.doubleQuotes);
  if (quotedSplice != null && (quotedSplice.tail == null || options.doubleBar === true)) {
    const prefix = writeString(quotedSplice.text, true);
    if (quotedSplice.tail == null) return prefix;
    return `${prefix}||${termToString(quotedSplice.tail, env, true, options)}`;
  }
  const parts = [];
  let cursor = term;
  while (true) {
    cursor = deref(cursor, env);
    if (isEmptyList(cursor)) return `[${parts.join(', ')}]`;
    if (!isCons(cursor)) {
      if (parts.length) return `[${parts.join(', ')} | ${termToString(cursor, env, true, options)}]`;
      return `[${termToString(cursor, env, true, options)}]`;
    }
    parts.push(termToString(cursor.args[0], env, true, options));
    cursor = cursor.args[1];
  }
}

export function termToString(term, env = new Env(), quoteStrings = true, options = {}) {
  options = {
    ...options,
    doubleQuotes: options.doubleQuotes ?? 'chars',
    // termToString is also used for context-free processor-error messages.
    // Keep the normal-profile `||` extension opt-in here so strict errors do
    // not accidentally emit syntax that the strict parser rejects.
    doubleBar: options.doubleBar === true,
    readVariableNames: options.readVariableNames instanceof Map ? options.readVariableNames : new Map(),
    usedReadVariableNames: options.usedReadVariableNames instanceof Set ? options.usedReadVariableNames : new Set(),
  };
  const resolved = deref(term, env);
  if (resolved.type === VAR) {
    if (resolved.displayName == null) return writeVariable(resolved.name);
    let printed = options.readVariableNames.get(resolved.name);
    if (printed == null) {
      const base = writeVariable(resolved.displayName);
      printed = base;
      let suffix = 1;
      while (options.usedReadVariableNames.has(printed)) printed = `${base}_${suffix++}`;
      options.readVariableNames.set(resolved.name, printed);
      options.usedReadVariableNames.add(printed);
    }
    return printed;
  }
  if (isCons(resolved)) return writeList(resolved, env, options);
  if (resolved.type === STRING) return writeString(resolved.name, quoteStrings);
  if (resolved.type === ATOM) return writeAtom(resolved.name);
  if (resolved.type === NUMBER) return resolved.name;
  if (resolved.type === COMPOUND && resolved.arity === 0) return writeAtom(resolved.name);
  if (resolved.type === COMPOUND && resolved.name === '{}' && resolved.arity === 1) {
    return `{${termToString(resolved.args[0], env, true, options)}}`;
  }
  if (resolved.type === COMPOUND && resolved.name === ':' && resolved.arity === 2) {
    return `${termToString(resolved.args[0], env, true, options)}:${termToString(resolved.args[1], env, true, options)}`;
  }
  if (isConjunction(resolved)) {
    const parts = [];
    let cursor = resolved;
    while (true) {
      cursor = deref(cursor, env);
      if (isConjunction(cursor)) {
        parts.push(termToString(cursor.args[0], env, true, options));
        cursor = cursor.args[1];
      } else {
        parts.push(termToString(cursor, env, true, options));
        break;
      }
    }
    return `(${parts.join(', ')})`;
  }
  return `${writeAtom(resolved.name)}(${resolved.args.map((arg) => termToString(arg, env, true, options)).join(', ')})`;
}

export function lexicalValue(term, env) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return null;
  if (resolved.type === ATOM || resolved.type === STRING || resolved.type === NUMBER) return resolved.name;
  return termToString(resolved, env, true);
}

export function properListItems(list, env) {
  const items = [];
  let cursor = deref(list, env);
  while (isCons(cursor)) {
    items.push(cursor.args[0]);
    cursor = deref(cursor.args[1], env);
  }
  if (!isEmptyList(cursor)) return null;
  return items;
}

export function listFromItems(items, start = 0, end = items.length, tail = emptyList()) {
  let result = tail;
  for (let i = end - 1; i >= start; i--) result = cons(items[i], result);
  return result;
}

export function flattenConjunction(goal) {
  const out = [];
  const stack = [goal];
  while (stack.length) {
    const current = stack.pop();
    if (isConjunction(current)) {
      stack.push(current.args[1], current.args[0]);
    } else {
      out.push(current);
    }
  }
  return out;
}

export function termSignature(term) {
  return term?.type === COMPOUND ? `${term.name}/${term.arity}` : null;
}

export function variantTerms(left, leftEnv, right, rightEnv, pairs = new Map(), reverse = new Map()) {
  // Variant checks sit on the recursive-call hot path. Use an explicit work
  // stack so long lists do not consume the JavaScript call stack.
  const pending = [[left, right]];
  const seen = new WeakMap();
  while (pending.length > 0) {
    [left, right] = pending.pop();
    left = deref(left, leftEnv);
    right = deref(right, rightEnv);
    if (left.type === VAR || right.type === VAR) {
      if (left.type !== VAR || right.type !== VAR) return false;
      if (pairs.has(left.name) || reverse.has(right.name)) {
        if (pairs.get(left.name) !== right.name || reverse.get(right.name) !== left.name) return false;
        continue;
      }
      pairs.set(left.name, right.name);
      reverse.set(right.name, left.name);
      continue;
    }

    if (left.type !== right.type || left.arity !== right.arity) return false;
    if (left.type === NUMBER ? !sameNumberValue(left.name, right.name) : left.name !== right.name) return false;
    if (left.type !== COMPOUND) continue;

    let rights = seen.get(left);
    if (rights?.has(right)) continue;
    if (rights == null) {
      rights = new WeakSet();
      seen.set(left, rights);
    }
    rights.add(right);
    for (let i = left.arity - 1; i >= 0; i--) pending.push([left.args[i], right.args[i]]);
  }
  return true;
}


function compareCharacterText(left, right) {
  let li = 0;
  let ri = 0;
  while (li < left.length && ri < right.length) {
    const ac = left.codePointAt(li);
    const bc = right.codePointAt(ri);
    if (ac !== bc) return ac < bc ? -1 : 1;
    li += ac > 0xffff ? 2 : 1;
    ri += bc > 0xffff ? 2 : 1;
  }
  return li < left.length ? 1 : ri < right.length ? -1 : 0;
}

export function compareTerms(left, right, variableRanks = null) {
  // ISO 7.2.1 deliberately leaves the order of distinct variables
  // implementation dependent.  Do not attach a permanent ordinal to a
  // logical variable: besides retaining implementation history, that would
  // make the chosen order observable outside the operation that needs it.
  // A caller that is constructing one sorted list can pass a shared Map so
  // every comparison in that operation uses one consistent variable order.
  const ranks = variableRanks ?? new Map();
  return compareTermsWithRanks(left, right, ranks);
}

function variableRank(name, ranks) {
  let rank = ranks.get(name);
  if (rank == null) {
    rank = ranks.size;
    ranks.set(name, rank);
  }
  return rank;
}

// ISO standard order: variables < numbers < atoms < strings < compound.
// Defined once to avoid allocating a fresh object literal on every comparison.
const TYPE_ORDER = { [VAR]: 0, [NUMBER]: 1, [ATOM]: 2, [STRING]: 3, [COMPOUND]: 4 };
const EMPTY_ENV = new Env();

function compareTermsWithRanks(left, right, variableRanks) {
  // Standard compare/3 is used alongside compare_si/3 in issue #105. Walk
  // argument pairs explicitly so long lists do not exhaust the host stack.
  const pending = [left, right];
  while (pending.length !== 0) {
    right = deref(pending.pop(), EMPTY_ENV);
    left = deref(pending.pop(), EMPTY_ENV);
    const lr = TYPE_ORDER[left.type] ?? 0;
    const rr = TYPE_ORDER[right.type] ?? 0;
    if (lr !== rr) return lr < rr ? -1 : 1;
    if (left.type === NUMBER) {
      const leftInteger = isDecimalInteger(left.name);
      const rightInteger = isDecimalInteger(right.name);
      if (leftInteger !== rightInteger) return leftInteger ? 1 : -1;
      const cmp = compareNumberText(left.name, right.name);
      if (cmp) return cmp;
    } else if (left.type === VAR) {
      if (left.name === right.name) continue;
      const leftOrder = variableRank(left.name, variableRanks);
      const rightOrder = variableRank(right.name, variableRanks);
      return leftOrder < rightOrder ? -1 : 1;
    } else if (left.type === ATOM || left.type === STRING) {
      const cmp = compareCharacterText(left.name, right.name);
      if (cmp) return cmp;
    } else {
      if (left.arity !== right.arity) return left.arity < right.arity ? -1 : 1;
      if (left.name !== right.name) return compareCharacterText(left.name, right.name);
      for (let i = left.arity - 1; i >= 0; i--) pending.push(left.args[i], right.args[i]);
    }
  }
  return 0;
}

const RE_DECIMAL_INTEGER = /^-?\d+$/;
export function isDecimalInteger(text) {
  return RE_DECIMAL_INTEGER.test(text ?? '');
}

export function compareIntegerText(left, right) {
  if (isDecimalInteger(left) && isDecimalInteger(right)) return compareIntegerValueText(left, right);
  // Preserve the public helper's historical acceptance/error behavior for host
  // BigInt spellings outside EyeProlog's decimal integer term syntax.
  const a = BigInt(left);
  const b = BigInt(right);
  return a < b ? -1 : a > b ? 1 : 0;
}

export function parseFiniteNumber(text) {
  if (text == null || text === '') return null;
  if (!RE_FLOAT.test(text)) return null;
  const n = Number(text);
  return Number.isFinite(n) ? n : null;
}

export function numberTextFromDouble(value) {
  if (!Number.isFinite(value)) return null;
  if (Object.is(value, -0)) value = 0;
  // Number#toString returns the shortest decimal spelling that round-trips to
  // the same IEEE-754 double. Keep that value identity while adapting the text
  // to ISO float syntax, which requires an explicit fractional part.
  let text = Number(value).toString();
  const exponent = text.search(/[eE]/);
  if (exponent >= 0) {
    if (!text.slice(0, exponent).includes('.')) {
      text = `${text.slice(0, exponent)}.0${text.slice(exponent)}`;
    }
  } else if (!text.includes('.')) {
    text += '.0';
  }
  return text;
}

export function compareNumberText(left, right) {
  if (isDecimalInteger(left) && isDecimalInteger(right)) return compareIntegerText(left, right);
  const a = parseFiniteNumber(left);
  const b = parseFiniteNumber(right);
  if (a != null && b != null) return a < b ? -1 : a > b ? 1 : 0;
  return left < right ? -1 : left > right ? 1 : 0;
}
