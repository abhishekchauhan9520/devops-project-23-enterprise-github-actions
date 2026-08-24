# Enterprise Release Controls

1. Pull requests run the reusable CI workflow across Node 20 and Node 22.
2. Main pushes build an immutable image tag based on the commit SHA.
3. The image is pushed to GHCR.
4. A container SBOM is generated and attached as a workflow artifact.
5. GitHub artifact attestation links the image digest and SBOM to build provenance.
6. Staging and production are separate GitHub Environments. Configure required reviewers on `production` in repository settings to create the real approval gate.
7. Cloud deployments should use OIDC trust to short-lived cloud roles rather than long-lived credentials.
8. For a hardened enterprise setup, pin third-party actions to full commit SHAs after organizational review.

The included promotion script intentionally creates an immutable release record instead of changing external infrastructure. This keeps the example safe to fork while preserving the CI/CD control-plane behavior.
