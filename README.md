# gray-handoff

Generate a focused handoff prompt for a fresh session via `host/run`. Port of
pi's `handoff` extension.

A sidecar plugin for [gray](https://github.com/vstaln/gray), scaffolded by
[gray-account](https://github.com/vstaln/gray-account).

## What it does

Every `context/build` serializes the outbound conversation (roles, text,
tool calls, truncated tool results) into `~/.gray/handoff/<sid>.txt`, capped
at ~200KB with the newest bytes kept. `/handoff <goal>` sends pi's handoff
`SYSTEM_PROMPT` plus the cached history and your goal through `host/run` (a
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
