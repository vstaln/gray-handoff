<div align="center">
  <img alt="gray-handoff" src="assets/icon.svg" width="120" height="120" />
  <h1>gray-handoff</h1>
  <p><strong>Generate a focused handoff prompt for a fresh session.</strong></p>
  <p>
    <a href="https://gray.alignment.id">Website</a> ·
    <a href="https://gray.alignment.id/plugins/gray-handoff">Store</a> ·
    <a href="https://github.com/vstaln/gray-handoff">Source</a> ·
    <a href="https://github.com/vstaln/gray">gray</a>
  </p>
  <p>
    <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-1c1c20?style=flat-square&labelColor=0a0a0b" /></a>
    <a href="https://www.rust-lang.org"><img alt="Built with Rust" src="https://img.shields.io/badge/built%20with-rust-1c1c20?style=flat-square&labelColor=0a0a0b&logo=rust&logoColor=d4a373" /></a>
    <a href="https://gray.alignment.id/plugins/gray-handoff"><img alt="gray plugin" src="https://img.shields.io/badge/gray-plugin-1c1c20?style=flat-square&labelColor=0a0a0b&color=7aa2f7" /></a>
  </p>
</div>

<br/>

```bash
gray plugin install gray-handoff
```

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

## Tags

`gray` `plugin` `handoff` `rust`

---
Part of the [gray](https://github.com/vstaln/gray) plugin ecosystem —
the open-source AI agent harness. <https://gray.alignment.id>
