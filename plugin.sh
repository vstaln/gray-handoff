#!/bin/sh
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sys="$(uname -s)"
case "$sys" in
MINGW* | MSYS* | CYGWIN*) rel="x86_64-pc-windows-msvc/gray-handoff.exe" ;;
Darwin*)
    case "$(uname -m)" in
    arm64) rel="aarch64-apple-darwin/gray-handoff" ;;
    *) rel="x86_64-apple-darwin/gray-handoff" ;;
    esac ;;
*)
    case "$(uname -m)" in
    aarch64 | arm64) rel="aarch64-unknown-linux-musl/gray-handoff" ;;
    *) rel="x86_64-unknown-linux-musl/gray-handoff" ;;
    esac ;;
esac
if [ -x "$here/$rel" ]; then exec "$here/$rel" "$@"; fi
for cand in "$here/target/release/gray-handoff.exe" "$here/target/release/gray-handoff" "$here/target/debug/gray-handoff.exe" "$here/target/debug/gray-handoff"; do
    if [ -x "$cand" ]; then exec "$cand" "$@"; fi
done
echo "gray-handoff binary not found in $here" >&2
exit 1
