---
name: sonar-issue-check
description: Check SonarQube/SonarCloud issues for the current repository with branch-aware context. Use when a user asks to check Sonar issues, open issues, security hotspots, or quality problems. Always read sonar-project.properties and .sonarcloud.properties first, then resolve PR context using gh CLI when available and query the matching Sonar PR; otherwise fall back to active branch mapping.
---

# Sonar Issue Check

## Workflow

1. Confirm Sonar configuration scope first.
- Read `sonar-project.properties` and `.sonarcloud.properties` when present.
- Extract and verify project identifiers and scan scope (`sonar.projectKey`, sources, exclusions).
- If both files exist, check they are aligned for key scope settings.

2. Resolve the active git context.
- Detect current branch with a non-interactive git command.
- Treat this branch as the default analysis target.

3. Map branch to Sonar PR context when possible.
- First try GitHub CLI for quick PR resolution from the active branch (for example `gh pr view --json number,headRefName`).
- If `gh` is unavailable, not authenticated, or returns no PR, list pull requests from Sonar for the project.
- If the active branch matches a PR source branch, query Sonar issues with `pullRequest`.
- If no PR mapping exists, query Sonar issues for that branch context when supported; otherwise query project issues and state the limitation.

4. Retrieve issue data.
- Query open actionable issues first (`OPEN`, `CONFIRMED` when available).
- Also retrieve Security Hotspots with `TO_REVIEW` status.
- If needed, fetch all statuses to distinguish resolved-only states from clean code.

5. Report results clearly.
- State exact project key, active branch, and whether PR or branch scope was used.
- Summarize counts by severity and type (bugs/vulnerabilities/code smells when available).
- Include key issue references: issue key, rule, status, severity, file path, and line.
- If nothing is open, explicitly say there are zero open issues and zero hotspots (or specify remaining reviewed/resolved findings).

## Response Requirements

- Use concrete values from the repository and Sonar responses; avoid assumptions.
- Include dates when useful for clarity (creation/update timestamps).
- If Sonar scope cannot be mapped to active branch/PR, state that explicitly and explain what scope was queried instead.
- Keep output concise, with a short summary first and then notable findings.
