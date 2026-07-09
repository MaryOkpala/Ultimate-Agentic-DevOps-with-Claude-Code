# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website for Pravin Mishra. Pure HTML5 + CSS3 — no JavaScript file, no build step, no package manager, no linter, no tests. There is currently no CI/CD and no infrastructure-as-code in this repo (a prior GitHub Actions workflow, Terraform-scaffolding skill, and related `.claude/skills/` deployment skills were all removed in commit `d0bc871`).

`README.md` documents the repo's original purpose: a DMI (DevOps Micro Internship) Week 1 exercise where students deploy this site to an Ubuntu VM via Nginx as a hosting/ownership-proof exercise, editing the footer with their own name/cohort details before deploying. That manual Nginx deployment is the only deployment path currently described anywhere in the repo — treat it as authoritative unless the user says otherwise.

## Commands

There is no build, lint, or test tooling. To preview locally, just open the file directly:

```bash
open index.html
```

## Architecture

- **index.html** (613 lines) — single-page layout with sections: navbar, `#home` (hero), `#about`, `#services`, `#courses`, `#book`, `#community` (learner trust), `#contact`, and a footer. Nav links scroll to these section anchors.
- **style.css** (1145 lines) — all styling for `index.html`, mobile-first with breakpoints at 900px, 768px, and 600px (repeated per-section rather than consolidated).
- **privacy.html** / **terms.html** — standalone pages with their own `<style>` blocks in `<head>`; they do **not** use `style.css`, so styling changes to the main site won't affect them and vice versa.
- **images/** — static assets (logo, profile photo, course thumbnails, hero background).
- Font Awesome icons are loaded from a CDN (`cdnjs.cloudflare.com`) in `index.html`'s `<head>` — the only external dependency in the project.

### Non-obvious gotcha: dead JS hooks

`index.html` has `onclick="goToSection(...)"` (on the nav logo and mobile menu buttons) and `onclick="toggleMenu()"` (hamburger icon), plus `<span id="year"></span>` in the footer intended for a dynamic copyright year. **None of these are backed by any JavaScript** — there is no `<script>` tag or `.js` file anywhere in the repo. These handlers are currently no-ops; the mobile hamburger menu does not open/close, and the footer year does not populate. If asked to fix mobile nav or the footer year, this is the root cause, not a typo elsewhere.
