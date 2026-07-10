---
name: audit-output-format
description: How the user wants terraform security audit results delivered
metadata:
  type: feedback
---

For terraform security audits in this repo, the user wants a read-only review: do not modify any `.tf` files. Deliver findings directly in the chat response (never as a written report/markdown file — the parent/user reads the text reply, not a file).

Findings should be ranked by severity (CRITICAL/HIGH/MEDIUM/LOW), each with the specific file/line reference, an explanation of what's wrong and why it matters, and a concrete fix — including an exact terraform code snippet where useful.

**Why:** explicit instructions given in the 2026-07-09 audit request emphasized "read-only audit; just report findings back to me" and "Do not modify any files."

**How to apply:** default to this format for any future terraform/security audit task in this repo unless the user explicitly asks for changes to be applied.
