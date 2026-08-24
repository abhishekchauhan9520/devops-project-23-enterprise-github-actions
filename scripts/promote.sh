#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-}"
IMAGE="${2:-}"
DIGEST="${3:-}"

case "$ENVIRONMENT" in
  staging|production) ;;
  *) echo "usage: $0 <staging|production> <image> <digest>" >&2; exit 2 ;;
esac

[[ -n "$IMAGE" ]] || { echo "image is required" >&2; exit 2; }
[[ "$DIGEST" =~ ^sha256:[0-9a-f]{64}$ ]] || { echo "digest must be a sha256 digest" >&2; exit 2; }

cat > promotion-record.txt <<RECORD
environment=$ENVIRONMENT
image=$IMAGE
digest=$DIGEST
commit=${GITHUB_SHA:-local}
timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
RECORD

cat promotion-record.txt
