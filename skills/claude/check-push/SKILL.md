---
name: check-push
description: When the user reports a discrepancy between local behavior and CI/CD behavior, check first and foremost whether the latest changes have been pushed to the remote branch before investigating further.
when_to_use: Use this whenever the user says something works locally but not on the runner/CI, or CI fails in a way that doesn't match what they see locally.
---

When the user reports that something works locally but fails on CI (or vice versa), **before doing any other investigation**, run:

```bash
git status
git log --oneline origin/$(git rev-parse --abbrev-ref HEAD)..HEAD 2>/dev/null || git log --oneline -5
```

If there are unpushed commits or uncommitted changes, tell the user immediately:

> "You have unpushed commits (or uncommitted changes). The CI run may be on an older version of the code. Push first, re-run CI, and see if the issue persists before we investigate further."

Only proceed with deeper investigation once it's confirmed that the remote branch is up to date with the local state.
