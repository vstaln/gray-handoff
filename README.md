<p align="center">
  <img src="assets/gray-logo.svg" alt="gray" width="96">
</p>
<h1 align="center">gray-handoff</h1>
<p align="center">Generates a focused handoff prompt for continuing work in a fresh session.</p>
<p align="center">
  <a href="https://github.com/vstaln/gray-handoff/blob/main/LICENSE"><img alt="MIT License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
  <img alt="gray plugin" src="https://img.shields.io/badge/gray-plugin-7aa2f7.svg">
  <img alt="rust" src="https://img.shields.io/badge/built%20with-rust-orange.svg">
</p>

A sidecar plugin for [gray](https://github.com/vstaln/gray), scaffolded by
[gray-account](https://github.com/vstaln/gray-account).

## What it does

Every `context/build` serializes the outbound conversation (roles, text,
tool calls, truncated tool results) into `~/.gray/handoff/<sid>.txt`, capped
at ~200KB with the newest bytes kept. `/handoff <goal>` sends a handoff
system prompt plus the cached history and your goal through `host/run` (a
`gray -p` turn) and replies with the generated prompt:

```
/handoff now implement this for teams as well
/handoff execute phase one of the plan
```

gray has no `newSession` wire API, so the handoff is **manual**: start a
fresh `gray` session and paste the prompt the command printed. `/handoff`
alone prints usage.

If `host/run` errors (capability not granted, timeout), you get the error as
plain text — nothing is lost, the cache stays warm for a retry.

## Wire methods

- `context/build` — observe-only cache fill (always replies `{}`, never
  replaces the message list)
- `command/run` — `/handoff <goal>`
- `plugin/manifest`, `plugin/shutdown`
- `host/run` — prompt generation (capability `host.turn`, needs consent:
  `gray plugin capabilities handoff --all`)

## Install

```sh
gray plugin install handoff
gray plugin capabilities handoff --all   # grants host.turn
```

## Develop

```sh
cargo test
cargo build --release
gray account check      # entry point + manifest handshake
gray account publish    # check → build → release → publish to the gray registry
```

Bump `version` in `Cargo.toml` before each `publish`; the registry refuses to
republish a version.

---
Part of the [gray](https://github.com/vstaln/gray) plugin ecosystem —
the open-source AI agent harness. <https://gray.alignment.id>
