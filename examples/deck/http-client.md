# HTTP client

## How does a Prolog program fetch and read a JSON document?

This example is a three-line relation: fetch a URL over HTTP(S) and parse the
body as JSON into an ordinary Prolog term. It depends on a live network
endpoint, so it has no built-in query; you supply the URL.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=http-client) ·
[Source](../http-client.pl)

---

# The question

Given a URL that returns JSON, what does the document say, and what HTTP
status code came back?

The point is the boundary: network I/O happens in one predicate, and
everything after it works on structured terms, not strings.

---

# The program

```prolog
:- use_module(library(http)).
:- use_module(library(json)).
:- use_module(library(dcgs)).

fetch_json(URL, JSON, Code) :-
    http_get(URL, Body, [status_code(Code), header("accept", "application/json")]),
    phrase(json_chars(JSON), Body).
```

`http_get/3` performs the request and returns the body as a list of
characters, with the status code as an option. `json_chars//1` is a grammar
(a DCG), so `phrase/2` parses the characters into a JSON term.

---

# The JSON term

The JSON grammar works in both directions. Parsing
`{"status":"ok","count":3}` gives:

```text
pairs([string("status") - string("ok"), string("count") - number(3)])
```

Objects become `pairs/1`, strings `string/1` and numbers `number/1`, so
later rules can match on the structure directly.

---

# The answer

```sh
eyeprolog --goal 'fetch_json("https://example.org/api/status", JSON, Code)' examples/http-client.pl
```

The answer depends on the endpoint, so the example declares no goal of its
own and its golden output file is empty. `library(http)` is backed by
Node's HTTP client, so run the request from the command line rather than the
browser playground.

---

# The reason

With no declared goal, the run makes no claims, so its proof is empty.
Run your own goal with `--proof` and the proof shows `fetch_json/3`
resting on the `http_get/3` and `phrase/2` calls.

The network call cannot be replayed by a proof checker. Treat the fetched
document as input that the host has to vouch for.

---

# The check

```text
condition('C1', resolution, ok, 0).
condition('C4', coverage, ok, 0).
condition('C7', relevance, ok, 0).
verdict(checked).
```

Every condition holds trivially: zero claims and zero steps. An empty proof
certifies nothing, and the check says so honestly.

---

# Try it

- Fetch a public JSON endpoint and extract one field by matching on
  `pairs/1`.
- Separate the network from the logic: save a response body to a file and
  parse it with `phrase/2` instead of `http_get/3`.
- See [`json`](../json.pl) for JSON parsing and generation without the
  network.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 15.
