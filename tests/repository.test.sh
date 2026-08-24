#!/usr/bin/env bash
set -euo pipefail

required=(README.md package.json package-lock.json Dockerfile .github/workflows/ci.yml .github/workflows/reusable-ci.yml .github/workflows/build-release.yml scripts/promote.sh)
for file in "${required[@]}"; do
  test -f "$file" || { echo "missing: $file"; exit 1; }
done

grep -q 'workflow_call:' .github/workflows/reusable-ci.yml
grep -q 'matrix:' .github/workflows/reusable-ci.yml
grep -q 'cache: npm' .github/workflows/reusable-ci.yml
grep -q 'environment:' .github/workflows/build-release.yml
grep -q 'id-token: write' .github/workflows/build-release.yml
grep -q 'attest@v4' .github/workflows/build-release.yml
grep -q 'anchore/sbom-action@v0.24.0' .github/workflows/build-release.yml
grep -q 'permissions:' .github/workflows/ci.yml

./scripts/promote.sh staging ghcr.io/example/app:deadbeef sha256:$(printf 'a%.0s' {1..64})
test -f promotion-record.txt
rm -f promotion-record.txt

echo 'Project 23 repository checks passed.'
