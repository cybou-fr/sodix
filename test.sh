#!/usr/bin/env bash
# Isolated functional smoke test: no checked-in keys and no command tracing.
set -euo pipefail
umask 077
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP="$(mktemp -d "${TMPDIR:-/tmp}/sodix-smoke.XXXXXXXX")"
trap 'rm -rf -- "$TEMP"' EXIT

if command -v sodix >/dev/null 2>&1; then
    sodix_cmd() { command sodix "$@"; }
else
    command -v cargo >/dev/null 2>&1 || { echo "sodix or cargo is required" >&2; exit 1; }
    sodix_cmd() { cargo run --quiet --manifest-path "$ROOT/Cargo.toml" -- "$@"; }
fi

sodix_cmd generate -k "$TEMP/alice" >/dev/null
sodix_cmd generate -k "$TEMP/bob" >/dev/null

alice_public="$(cat "$TEMP/alice/enc_public.key")"
alice_private="$(cat "$TEMP/alice/enc_secret.key")"
bob_public="$(cat "$TEMP/bob/enc_public.key")"
bob_private="$(cat "$TEMP/bob/enc_secret.key")"
message="Sodix temporary-key smoke test"

ciphertext="$(sodix_cmd encrypt --pubkey "$bob_public" --seckey "$alice_private" "$message")"
recovered="$(sodix_cmd decrypt --pubkey "$alice_public" --seckey "$bob_private" "$ciphertext")"

if [[ "$message" != "$recovered" ]]; then
    echo "FAIL: decrypted message does not match" >&2
    exit 1
fi
echo "PASS: isolated encrypt/decrypt roundtrip (temporary keys removed)"
