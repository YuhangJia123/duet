---
name: duet
description: Coordinate Codex project work with a strong planning model and lower-cost execution agents while controlling context and verifying results. Use for /duet, $duet, duet requests, or substantial tasks that benefit from model-split delegation; keep small tasks inline.
---

# duet

Use the current root as coordinator; prefer Astra for architecture, difficult decisions,
integration and final verification. Delegate bounded implementation and investigation
to Sol. Optimize accepted results per cost, not agent count or output brevity alone.

This skill is self-contained: all execution rules are included here. Do not load or
require cavecrew or any upstream skill/runner. Source links are attribution and
optional background, not execution dependencies. Native host subagent tools and
available models remain runtime prerequisites.

## Invocation

Treat `/duet` (when delivered as user message text) and `$duet` as requests to apply
this skill to the current task. With a task after the invocation, start that work.
With a bare invocation, continue the latest unresolved task when it is clear; do not
require the user to repeat it. If there is no actionable task, briefly acknowledge
readiness and ask for the task. Apply the workflow to this task, not unrelated future
requests. Invocation does not authorize a model switch or new external actions.

This is a message trigger, not registration of a native slash command. Hosts that
intercept unknown slash commands may reject `/duet` before it reaches the agent.
Use the host's skill picker or `$duet` in those hosts; do not claim an alias was
installed merely by changing this file.

## Select the route

- Read applicable project instructions and inspect existing changes before assigning work.
- Read `models.json` in this skill directory before routing. It contains the default
  coordinator and worker model IDs. Explicit user choices for this task override
  these defaults; project/runtime instructions still govern execution. Do not persist
  a one-task override unless the user requests changing the defaults.
- Default coordinator: `gpt-6-astra`; default worker: `gpt-6.1-sol`. Use the values
  actually read from `models.json`, rather than treating these examples as fixed.
- Compare the running root model with the selected coordinator. A skill cannot
  change its own running model. Disclose a mismatch and continue useful work on the
  current root unless the user requires the exact coordinator; never claim a switch.
- Check that the selected worker is exposed by the host. Do not silently substitute
  a different version or Astra if it is unavailable. Explain the mismatch and handle
  bounded work inline when that still meets the user's task.
- Use native subagent tools when available. In hosts exposing
  `collaboration.spawn_agent`, set `model` to the resolved worker ID explicitly and
  `fork_turns: "none"` for a compact handoff. That host only permits model overrides
  without a history fork. Other hosts: inspect their actual role/model configuration;
  do not invent tool arguments or assume an agent named worker uses Sol.
- A skill authorizes this delegation workflow within the user's task, not new
  external writes, permission bypasses, or changing billing credentials. Model
  selection does not select a provider, API account, subscription or billing route.
  Report actual routing only when observed; never claim Sol is on API merely by name.
- Do not edit global model defaults or install a third-party runner to execute a task.

## Decide whether to delegate

Keep tiny changes, one-command checks, tightly coupled decisions and already-understood
single-file fixes inline. Delegate a task when it has a concrete deliverable, limited
dependencies and enough work to justify a separate context. Do not create a mandatory
explore → build → test → review chain.

For a substantial task with unknown entry points, dependencies or failure cause, start
with one bounded, read-only worker investigation when that is cheaper than broad root
exploration. Ask for relevant locations, evidence,
possible independent scopes and verification commands. Stop scouting once this is
enough to make a routing decision. Skip it when the task is already understood. The
coordinator owns architecture and decides whether to reuse the investigator as builder.

Choose worker count from the actual work; there is no fixed two-worker ceiling.
Start with zero for small or tightly coupled tasks, one for bounded implementation,
and two for clearly independent scopes. Add further workers only when each has a
useful independent deliverable and disjoint ownership, within the host's available
slots (including the coordinator). Do not fill slots merely because they are free.
Consider repeated context, integration cost, test/resource contention, and user budget
before expanding. Reduce concurrency or sequence tasks when these costs dominate.
Reuse an existing worker for related follow-ups. Workers must not spawn more workers
unless the coordinator explicitly assigns a nested task.

Before dispatch, form the dependency order and assign one integration owner: the root
coordinator. Parallelize only tasks whose inputs are ready and whose write scopes do
not overlap. Give every assignment a concrete deliverable and stop condition. Reserve
the stronger coordinator model for decisions, ambiguous failures, and review that can
materially change acceptance; route routine bounded execution to the cheaper worker.

Useful roles (same Sol model, selected per need):
- Investigator: locate definitions, callers and failure evidence; read-only.
- Builder: implement a bounded change and its relevant checks.
- Verifier: independently examine a material acceptance risk; no ceremonial review.

## Give each worker a contract

Pass the minimum sufficient context rather than the full conversation. Include:

```text
Goal: observable result and relevant user constraints.
Workspace: absolute directory; applicable instructions to read.
Ownership: files allowed to edit, files read-only, other workers' scopes.
Context: verified findings, interfaces, exact paths, important uncertainties.
Acceptance: behavior to demonstrate and relevant existing check commands.
Limits: no unrelated edits, no commits/pushes unless authorized; report blockers.
Return: changed paths, result, checks with outcomes, unresolved risks.
```

Keep handoffs asymmetric: give workers only the constraints, interfaces, and evidence
needed for their assignment; return a compact evidence summary to the coordinator.
For investigation, prefer exact `path:line` references and a short finding over copied
files or broad narrative. For implementation, include changed paths, behavior,
verification, and remaining uncertainty. The coordinator should read cited source or
diff hunks only where needed to decide or verify; do not ask workers to omit decisive
evidence just to make the reply shorter.

Workers share a filesystem unless the host explicitly provides isolation. Give each
writer disjoint files, including tests and generated files. Sequence dependent edits
and shared build steps. Do not overwrite other work. Use isolated worktrees only when
needed for conflicting edits and supported by the user's task and repository policy.

Apply the current project instructions and authorization boundaries to every worker.
Resolve the active application, supported entry points, protected components and
required checks from that project rather than assuming a repository layout or domain.
Delegation does not grant approval for restricted executions or external actions.

## Integrate and verify

Ask for compact evidence, not a replay of tool logs:

```text
Result: completed | partial | blocked
Changed: absolute paths and short purpose
Evidence: checks actually run, outcomes, relevant path:line or artifact
Remaining: failures, assumptions, missing verification
```

An investigator can return path:line findings; a builder must include behavior and
verification, not merely “file reread OK.” Preserve enough detail to assess failures.

Inspect the diff and evidence before accepting a worker claim. Run the task's required
integration checks once; repeat only for changes, failures or remaining uncertainty.
Give one focused corrective follow-up for a bounded failure; on a repeated identical
failure, the coordinator diagnoses or revises the decomposition instead of spawning
equivalent retries. Escalate to Astra judgment for ambiguous contracts or domain errors.

For long-running workers, use the host's completion notification or wait mechanism
when available. Avoid frequent status polling; check state only when a decision depends
on it. After a stall, ask for current state and the smallest blocker, then recover once
with a focused next step instead of repeating the same delegation.

Stop assigning work when acceptance is met. Wait for assigned workers and resolve
their outputs, or explicitly end obsolete work. Final response states the outcome,
verification and limitations, in the user's language.

## Reduce context without losing evidence

- Search for the named symbol or behavior first. Expand to callers, tests, and adjacent
  files only when evidence requires it. If the relevant path is already known, skip
  exploratory delegation.
- Ask tools for targeted ranges and decisive error lines. Avoid dumping whole files,
  full logs, generated bundles, or repeated status output into the coordinator context.
- Keep raw evidence available at its source. Summaries and structured tool output are
  navigation aids, not replacements for source, diffs, exact errors, or test results.
  If a compressed result is ambiguous or parsing fails, inspect the original evidence.
- Do not reread files or replay tool output already present in context unless the file
  changed or verification requires a fresh read. Prefer a focused diff over reprinting
  the full file.
- Keep final answers concise but preserve important qualifications, failures, safety
  boundaries, and physical/domain assumptions. Never trade correctness for brevity.
- Do not claim savings from terse style alone. It mainly affects output tokens; it does
  not remove input context or reasoning. Measure total usage when reporting savings.

## Control cost

Use moderate effort for routine Sol implementation; increase it only for a specific
reasoning need. Respect the user's chosen effort and the host's supported levels.
Do not apply maximum effort or speed surcharges by default.

Charge the comparison with all root and worker input, cached input, output/reasoning,
tool-result context, integration and retries. A fresh context reduces history transfer
but still loads instructions and task context. Parallelism reduces elapsed time,
not necessarily billed tokens. Missing usage counters mean unknown savings.

Read [cost-and-sources.md](references/cost-and-sources.md) only when explaining costs
or evaluating whether this split saves money.
