---
name: portfolio-infra-baseline
description: Known/recurring security gaps in terraform/ for the static portfolio site (S3 + CloudFront), as of 2026-07-09 audit
metadata:
  type: project
---

Repo: Ultimate-Agentic-DevOps-with-Claude-Code, static HTML/CSS portfolio site deployed via S3 (private, OAC-fronted) + CloudFront, provisioned in `terraform/` (main.tf, outputs.tf, providers.tf, variables.tf, backend.tf).

As of the 2026-07-09 audit, the stack correctly implements: S3 Block Public Access (all 4 settings true), BucketOwnerEnforced ownership controls (no ACLs), CloudFront OAC (not legacy OAI) with a bucket policy scoped via `AWS:SourceArn` condition to the specific distribution, and `viewer_protocol_policy = "redirect-to-https"`.

Recurring gaps identified (not yet fixed as of this audit):
- No `aws_s3_bucket_server_side_encryption_configuration` — no encryption at rest.
- No `aws_s3_bucket_versioning` — no rollback protection for deploy overwrites.
- No CloudFront `logging_config` and no S3 access logging.
- No `aws_cloudfront_response_headers_policy` — missing CSP/X-Frame-Options/HSTS.
- No TLS-enforcement (`aws:SecureTransport` deny) statement on the S3 bucket policy.
- `backend.tf`'s S3 backend block is commented out (local state) and, when enabled, has no state locking (`dynamodb_table` or `use_lockfile`).
- No `.gitignore` exists anywhere in the repo — risk of accidentally committing `terraform.tfstate` / `.terraform/`.
- `variable "domain_name"` is declared in variables.tf but never referenced in main.tf (no `aliases`/ACM cert wiring on the CloudFront distribution) — distribution relies on `cloudfront_default_certificate`, which caps TLS below 1.2 enforcement.

**Why it matters for future audits:** this project has no IAM resources or GitHub Actions OIDC config inside `terraform/` (only the 5 files above) — those likely live elsewhere (e.g. `.github/workflows/`) and should be checked separately if asked to audit OIDC trust policies or CI credentials.

**How to apply:** on a re-audit, check whether these specific gaps were closed rather than re-deriving them from scratch; if still open, they are appropriate to re-flag at the same severities used previously (encryption/versioning/state-locking/.gitignore ~ HIGH, headers/logging/TLS-enforcement/custom-domain ~ MEDIUM).
