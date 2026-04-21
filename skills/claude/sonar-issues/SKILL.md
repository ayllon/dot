---
name: sonar-issues
description: This skill should be used when the user asks about SonarQube or SonarCloud issues, mentions "check sonar", "sonar issues", "what does sonar say", "sonar problems", "critical issue in sonar", "cognitive complexity", "complexity issues", or any question about code quality issues detected by SonarQube/SonarCloud on the current branch or PR.
version: 1.0.0
userInvocable: true
---

# SonarQube Issues Check

Fetch and display open SonarQube/SonarCloud issues for the current PR or branch.

## Steps

1. **Find the PR number** for the current branch:
   ```bash
   gh pr list --head $(git branch --show-current)
   ```

2. **Find the project key** by reading `sonar-project.properties` in the repo root:
   ```bash
   grep '^sonar.projectKey=' sonar-project.properties | cut -d'=' -f2
   ```
   If the file is missing or the key is not found, tell the user and stop.

3. **Search for issues** using the MCP SonarQube tool:
   - If a PR number is found: use `search_sonar_issues_in_projects` with `pullRequestId`
   - If no PR: use `search_sonar_issues_in_projects` with `branch`
   - Use the project key read from `sonar-project.properties`
   - Filter to `issueStatuses: ["OPEN"]`

4. **Display results** grouped by severity (BLOCKER → CRITICAL → MAJOR → MINOR → INFO):
   - Show: severity, rule ID, file path + line number, message
   - Show total count per severity and overall

## Output Format

```
PR #N — X open issues

CRITICAL  python:S3776  groundhog/tools/cli.py:81
          Refactor this function to reduce its Cognitive Complexity from 31 to 15.

MAJOR     pythonarchitecture:S7788  groundhog/tools/cli.py:1
          Remove this disallowed relationship to "config.py"
...
```

If no issues: "No open SonarQube issues found."
