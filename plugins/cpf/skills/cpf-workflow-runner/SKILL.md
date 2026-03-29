---
name: cpf-workflow-runner
description: Run, resume, and manage checkpointflow workflows interactively. Use this skill whenever the user wants to run a workflow, execute a YAML pipeline, resume a paused run, check workflow status, cancel a run, or interact with cpf at runtime. Also triggers on phrases like "run the workflow", "execute this", "resume the run", "what's the status", or when the user provides input for a waiting workflow step.
---

# cpf-workflow-runner

Run checkpointflow workflows interactively, handling pause/resume cycles with the user.

## Critical: Collect input through structured prompts, not chat

Every time the workflow needs input from the user — whether collecting workflow inputs before `cpf run`, gathering event data at an `await_event` pause, or confirming a cancellation — present structured choices using whatever interactive prompt tool is available in your environment (e.g., a question/answer UI, a selection picker, a form). The user should experience the workflow as a guided flow where they pick options and provide values through structured prompts, not by typing free-form messages into chat.

Do not say "what would you like to do?" and wait for a text reply. Always present choices and collect input through a structured prompt tool.

## Finding workflows

When the user asks to run a workflow without giving a full path, search these locations in order:

1. The path the user provided (if any)
2. `.checkpointflow/` in the current working directory
3. `~/.checkpointflow/`
4. `examples/` in the current project (if it's a checkpointflow repo)

Use glob patterns like `**/*.yaml` to find workflow files. If multiple matches exist, use a structured prompt tool to let the user pick which one.

If no workflows are found, tell the user and suggest they create one (the `cpf-workflow-author` skill can help with that).

## Running a workflow

### Step 1: Present the workflow

When the envelope comes back (from `cpf run` or `cpf resume`), use `workflow_name` and `workflow_description` from the JSON envelope to introduce the workflow to the user. This gives context even if you haven't read the YAML file.

### Step 2: Identify inputs

Read the workflow YAML to check what inputs it requires:
- Look at `workflow.inputs.required` and `workflow.inputs.properties`
- If the user hasn't provided inputs, use a structured prompt tool to collect them
- For complex inputs, ask the user to provide JSON

### Step 3: Build good prompt options from the schema

For each input property, build AskUserQuestion options using this priority:

1. **`enum` array** → one option per enum value (the user picks one)
2. **`type: boolean`** → two options: "Yes" / "No"
3. **`examples` array** → one option per example value (the user picks one or types "Other" for a custom value). This is the key mechanism for free-text fields — workflow authors provide examples that become real, meaningful options.
4. **`description` with inline examples** → if the description contains patterns like `e.g. "foo", "bar"` or `(e.g. "foo", "bar")`, extract those values and use them as options
5. **No examples available** → use the `description` text itself to craft 2 meaningful, distinct example options that illustrate the expected format

**Never create placeholder options** like "Type value" or "Enter value". Every option should be a real, plausible value the user might choose.

### Step 4: Execute

```bash
cpf run -f <path> --input '<json>'
```

Parse the JSON envelope from stdout. The `ok`, `status`, and `exit_code` fields tell you what happened.

### Step 5: Handle the result

Based on `exit_code`:

| Exit code | What happened | What to do |
|-----------|--------------|------------|
| 0 | Completed | Show the `result` to the user. Done. |
| 40 | Waiting for input | Enter the interactive loop (see below). |
| 10 | Validation error | Show `error.message`. Check inputs match the schema. |
| 30 | Step failed | Show which step failed and why. Offer to inspect with `cpf inspect`. |
| 80 | Unsupported step | Tell the user this step kind isn't implemented yet. |
| Other | Error | Show the error and suggest next steps. |

## Interactive loop (await_event handling)

This is the core of the skill. When a workflow pauses at an `await_event` step (exit code 40), the envelope contains a `wait` block:

```json
{
  "workflow_name": "My Workflow",
  "workflow_description": "What this workflow does",
  "wait": {
    "audience": "user",
    "event_name": "approval",
    "prompt": "Review and approve or reject.",
    "input_schema": { ... },
    "resume": {
      "command": "cpf resume --run-id <id> --event approval --input @event.json"
    }
  }
}
```

Handle it like this:

1. **Read the wait block** — extract `prompt`, `input_schema`, `event_name`, and `run_id`.

2. **Collect input using AskUserQuestion** — map each field in `input_schema` to a question using the same option-building rules from Step 3 above:
   - `enum` → one option per value
   - `boolean` → "Yes" / "No"
   - `examples` array → one option per example (user can always pick "Other")
   - Free-text without examples → craft 2 realistic example values from context

   **Multiple fields:** If `input_schema` has multiple `required` fields, ask them together in a single prompt call when possible. Optional fields can be asked in a follow-up or skipped.

   **Use the `prompt` from the wait block** as context when presenting the questions — it explains what the user is deciding on.

   **Example:** For this schema:
   ```json
   {"required": ["decision"], "properties": {"decision": {"type": "string", "enum": ["approve", "reject"]}, "notes": {"type": "string"}}}
   ```
   Present a structured prompt with:
   - Question 1 (Decision): options "approve" / "reject"
   - Question 2 (Notes): options "No notes" / "Looks good, minor nits" (realistic examples, not placeholders)

3. **Build the event JSON** from the user's answers. Map each answer back to the field name in `input_schema`. Make sure the result matches the schema types (strings stay strings, numbers get parsed).

4. **Resume the workflow:**
   ```bash
   cpf resume --run-id <run_id> --event <event_name> --input '<event_json>'
   ```

5. **Parse the new envelope** and loop back:
   - If exit code 0 → done, show result
   - If exit code 40 → another await_event, repeat from step 1
   - If error → show it

Keep looping until the workflow completes, fails, or the user wants to stop.

**Example interaction flow:**

```
User: run the agent-decision workflow
→ cpf run -f examples/agent-decision.yaml --input '{"data_source": "sales_q1"}'
→ Exit 40: waiting at "review" step
→ Structured prompt: "Review the analysis and approve or request changes." [approve / revise]
→ User picks "approve"
→ cpf resume --run-id abc123 --event review_decision --input '{"action": "approve"}'
→ Exit 0: completed with result {"outcome": "applied"}
→ Show result to user
```

## Status and inspection

When the user asks about a run:

```bash
cpf status --run-id <run_id>    # Quick status check
cpf inspect --run-id <run_id>   # Full execution history
```

If the user doesn't remember the run ID, check recent output from previous commands in the conversation — the `run_id` is in every envelope.

## Cancelling a run

When the user wants to cancel a waiting run:

```bash
cpf cancel --run-id <run_id> --reason "<reason>"
```

Use a structured prompt to confirm before cancelling, and ask for a reason if not provided.

## Web dashboard

Launch the GUI to browse workflows and runs visually:

```bash
cpf gui                    # opens http://localhost:8420
cpf gui --port 9000        # custom port
```

The dashboard shows workflow graphs with all step types rendered, run history with search/sort, and step detail panels.

## Tips

- Always parse the JSON envelope — don't rely on exit codes alone. The envelope has richer information.
- Exit code 40 is not an error. Don't treat it as a failure or apologize for it.
- When showing results to the user, format them nicely — don't dump raw JSON unless they ask for it.
- If a workflow has multiple sequential `await_event` steps (like a quiz), keep the loop going smoothly without re-explaining the process each time.
- The `--input` flag accepts either inline JSON (`'{"key": "value"}'`) or a file reference (`@path/to/file.json`). Prefer inline for simple inputs.
- Use `workflow_name` and `workflow_description` from the envelope to provide context to the user, especially on the first interaction.
