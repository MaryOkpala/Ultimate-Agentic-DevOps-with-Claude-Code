# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website (no JavaScript, no build step) deployed to AWS via S3 + CloudFront. Deployment is automated by GitHub Actions on push to `main`, using OIDC for AWS auth. The live AWS resources (S3 bucket `pravinmishradmi-site-production`, CloudFront distribution `E3V6O6MRE2E21P`, region `eu-north-1`) already exist and are referenced directly in `.github/workflows/deploy.yml` — there is currently no `terraform/` directory in this repo, so those resources are not (yet) managed as code here. Use the `scaffold-terraform` skill to generate Terraform that brings them under IaC management.

Note: `README.md` describes an older/unrelated exercise (DMI Week 1 — hosting this same site on an Ubuntu VM with Nginx). That is not how this repo is actually being deployed; ignore it for infrastructure guidance and treat `.github/workflows/deploy.yml` as the source of truth.

## Architecture

### Application (Static Site)
- **index.html** — Single-page portfolio (Navbar, Services, Courses, Books, Learners/Trust, Contact, Footer)
- **style.css** — All styling (~1145 lines), mobile-first responsive (breakpoints: 900px, 768px, 600px)
- **privacy.html / terms.html** — Standalone pages with their own inline styles (not shared with style.css)
- **images/** — Static assets (logo, profile, course thumbnails, hero background)
- Pure HTML5 + CSS3, no JavaScript, no package.json, no build/lint/test tooling

### CI/CD (`.github/workflows/deploy.yml`)
- Triggers on push to `main`
- Assumes AWS IAM role `github-actions-deploy` via OIDC (no stored credentials)
- Syncs repo to S3 with `aws s3 sync . s3://pravinmishradmi-site-production --delete`, excluding `.git/`, `.github/`, `.claude/`, `terraform/`, `.mcp.json`, and `*.md`
- Invalidates the CloudFront distribution (`--paths "/*"`) after sync

## Skills (`.claude/skills/`)

Infrastructure/deployment tasks are handled via skills rather than manual commands. All are manual-invocation only (`disable-model-invocation: true`):

```
/scaffold-terraform [region] [name]  → Generate terraform/ (S3 + CloudFront) per template-spec.md
/tf-plan                             → Run `terraform plan` in terraform/ and summarize risk/blast radius
/tf-apply                            → Run `terraform apply -auto-approve` and verify outputs
/deploy                               → Sync site to S3 + invalidate CloudFront (manual equivalent of the CI job)
```

`scaffold-terraform`'s full spec (bucket policy, OAC, cache behavior, backend.tf pattern) lives in `.claude/skills/scaffold-terraform/template-spec.md` — read it before generating or hand-editing Terraform.

## Commands

```bash
# Local preview — just open the file, no dev server
open index.html

# Once terraform/ exists (see /scaffold-terraform), prefer the skills above over raw commands;
# raw equivalents:
cd terraform && terraform init
cd terraform && terraform plan
cd terraform && terraform apply

# Manual S3 sync (CI does this automatically on push to main)
aws s3 sync . s3://pravinmishradmi-site-production --delete \
  --exclude ".git/*" --exclude ".github/*" --exclude ".claude/*" \
  --exclude "terraform/*" --exclude ".mcp.json" --exclude "*.md"
```

There is no lint, test, or build command in this repo — it's pure static HTML/CSS.

## Conventions
- GitHub Actions uses OIDC — no long-lived AWS access keys should be introduced
- Prefer the skills above over hand-written Terraform or ad hoc `aws`/`terraform` commands so infra stays consistent with `template-spec.md`
- Site content changes deploy automatically via GitHub Actions on push to `main` — no manual S3 sync needed for normal edits
