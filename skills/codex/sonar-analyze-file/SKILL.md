---
name: sonar-analyze-file
description: Analyze a single source file with SonarQube CLI SQAA and report actionable findings. Use when the user asks to run `sonar analyze sqaa`, analyze a file with Sonar/SQAA, inspect Sonar issues for one file, or determine a function's complexity after a file analysis.
---

# Sonar Analyze File

## Workflow

1. Run SQAA with the explicit file flag:

   ```bash
   sonar analyze sqaa --file <path>
   ```

2. If the command says no project is configured, read local Sonar configuration and rerun with explicit context:

   - Read `sonar-project.properties` first for `sonar.projectKey`.
   - Read `.sonarcloud.properties` when present to understand autoscan differences, but prefer `sonar-project.properties` when the CLI needs a project key.
   - Get the branch with `git rev-parse --abbrev-ref HEAD`.
   - Rerun:

     ```bash
     sonar analyze sqaa --project <projectKey> --branch <branch> --file <path>
     ```

3. If sandboxing blocks keychain, credential, or `~/.sonar` state access, rerun the same Sonar command with escalated permissions. Use a concise justification that the Sonar CLI needs local credentials and state.

4. Report the SQAA findings exactly enough to be useful: issue count, line, rule key, and message. Say clearly when SQAA does not report the requested metric.

## Complexity Follow-Up

When the user asks for a function's complexity and SQAA does not report it:

1. Locate the function with `rg -n "^def <name>|<name>\\(" <path>` for Python, or the language-appropriate declaration search.
2. Read the function body.
3. Distinguish the likely metric:

   - **Cyclomatic complexity**: count independent control-flow paths.
   - **Cognitive complexity**: Sonar's maintainability rule metric, sensitive to nesting and control-flow interruptions.

4. If exact Sonar cognitive complexity is required and no analyzer output reports it, say that SQAA did not expose the value and provide the best local calculation with the method used.

For Python, a quick AST check is useful for locating functions:

```bash
uv run python -c "import ast, pathlib; p=pathlib.Path('<path>'); t=ast.parse(p.read_text()); print([n.lineno for n in ast.walk(t) if isinstance(n, ast.FunctionDef) and n.name=='<name>'])"
```

Keep the final answer short: include the command outcome, whether Sonar reported the metric, and the calculated or inferred complexity value when available.
