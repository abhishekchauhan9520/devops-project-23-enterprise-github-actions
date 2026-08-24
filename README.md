# Project 23 — Enterprise GitHub Actions CI/CD

An enterprise-style GitHub Actions reference project demonstrating reusable workflows, matrix testing, dependency caching, artifact handoff, container builds, environment-gated promotion, concurrency controls, least-privilege permissions, OIDC-ready cloud authentication, and build provenance/SBOM attestations.

## Architecture

```text
Pull Request
   │
   ▼
Reusable CI Workflow
   ├── Node 20 / 22 matrix
   ├── npm cache
   ├── tests
   └── test artifact

main/tag
   │
   ▼
Build & Release
   ├── CI gate
   ├── Build immutable container
   ├── GHCR package
   ├── SBOM
   ├── Build provenance attestation
   ├── Staging environment gate
   └── Production environment gate
```

## Enterprise controls demonstrated

- Reusable workflows centralize deterministic CI logic.
- `permissions` are explicitly minimized; cloud-facing jobs can opt into `id-token: write` only when needed.
- Concurrency cancels superseded non-production runs.
- Matrix testing validates Node 20 and 22.
- Dependency caching uses the npm lockfile.
- Build artifacts and release records are passed between jobs instead of rebuilding silently.
- GitHub Environments separate staging and production promotion.
- Production promotion is controlled by the `production` environment; configure required reviewers in repository settings for a real approval gate.
- OIDC is the preferred pattern for short-lived cloud access instead of long-lived cloud keys. GitHub documents OIDC and its use with reusable workflows for standardized deployment trust.
- Container build provenance and SBOM attestations establish a verifiable link between the artifact and the workflow that built it. GitHub documents artifact attestations and their relationship to SLSA build levels.
- Current major versions are used in this learning repository; a hardened enterprise implementation should pin third-party actions to full commit SHAs after organizational review.

## Local validation

```bash
npm ci
npm test
npm start
```

Then open `http://127.0.0.1:3000/healthz`.

## Repository settings for the full demo

Create GitHub Environments named `staging` and `production`. Configure required reviewers on `production` if you want a real approval gate.

For cloud deployment, configure OIDC trust in the target cloud to the repository/environment rather than storing long-lived cloud access keys. The included promotion jobs intentionally create immutable release records instead of changing external infrastructure, so the repository is safe to fork and run without cloud credentials.

## What to extend next

Replace the promotion script with a real deployment adapter for Kubernetes, ECS, EC2, or another target. Keep the environment boundary, immutable image digest, OIDC trust, and approval controls intact.
