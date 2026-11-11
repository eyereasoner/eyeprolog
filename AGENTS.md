# Working on EyeProlog

EyeProlog is a dependency-free ISO Prolog implementation in JavaScript with
answers and inspectable proofs. Keep changes consistent with the existing
ES modules, documentation, saved examples and test runners. Preserve upstream
test bytes and expectations; do not change fixtures to hide a failing case.

## Tests and upstream sources

`npm test` runs the full suite, including the eight Neumerkel/WG17 sources in
Git-ignored `.cache/neumerkel/`. It reuses a complete cache and downloads all
eight sources if the cache is missing, incomplete or fails its recorded hashes.
`npm run sync` explicitly refreshes upstream, checks every discovered case and
updates `test/conformance/NEUMERKEL-LATEST.md`. Do not add a clean command for
this cache or vendor the downloaded suites into Git.

`npm run neumerkel` forces a fresh download and requires the tracked report to
match. `node test/run-neumerkel.mjs --cached` never downloads.
`npm test -- --offline` skips the upstream suites. `test/README.md` and
`test/conformance/NEUMERKEL-LIVE.md` describe the runners and report maintenance.

Run focused checks while working, then the full suite before finishing code
changes. Run `git diff --check` before committing. This machine has little
memory: run the full suite and releases under a cap with no swap, and never
start a second heavy local job alongside one already running:

```sh
systemd-run --user --scope -q -p MemoryMax=3G -p MemorySwapMax=0 -- npm test
```

## Versions and releases

Commit directly to `main`. Follow the user's instructions about committing,
pushing and releasing. Do not use closing keywords such as `Fixes #N` in
commit messages; issues are closed by hand.

`package.json` is the version source. Never bump it by hand. Cut releases
with the release script, supplying a descriptive message explicitly:

```sh
systemd-run --user --scope -q -p MemoryMax=3G -p MemorySwapMax=0 -- ./release patch "Describe the changes"
```

Use `minor` or `major` when appropriate. Every release message must describe
what changed; never use only `Release vX.Y.Z` or a version number. Keep the
message as the release commit subject and annotated tag message, include it
in the GitHub release title and description, and show it as the Actions run
title for testing, publishing, release creation and Pages deployment. Keep
the explicit `run-name` expressions in all four workflows. After releasing,
check the Actions titles and outcomes, GitHub release and npm publication.

The script switches to `main`, pulls with `--ff-only`, and uses `npm version`
with the package hooks. The preversion hook regenerates library and book
files, runs `npm run sync` once, tests that same cached snapshot, and stages
the conformance reports. The release script commits the version bump,
creates an annotated `v*` tag and pushes the branch and tag. `main` runs tests
and deploys Pages; the tag creates the GitHub release and publishes `eyeprolog`
through the trusted-publishing workflow. Preserve published tags.
