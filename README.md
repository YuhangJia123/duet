# duet

`duet` is a self-contained Codex skill for coordinating project work across models. Its default pairing is GPT-6 Astra as coordinator and GPT-6.1 Sol as the execution model. The coordinator owns planning, difficult decisions, integration, and final verification. Sol agents handle bounded investigation and implementation.

The skill is repository-agnostic. It follows the active project's own instructions, tools, ownership boundaries, and acceptance checks. It does not assume a language, framework, or repository layout.

## Design

```text
Request
  -> Coordinator understands the goal and defines contracts
  -> Sol investigates only when scope or cause is unclear
  -> Sol workers execute bounded, non-overlapping tasks
  -> Coordinator integrates, checks evidence, and verifies acceptance
```

Small understood tasks stay inline. Substantial tasks with unknown entry points may start with one read-only investigation. Parallel workers are added only when independent deliverables justify their context and integration cost. There is no fixed worker limit: the host's capacity, file ownership, task dependencies, and budget determine the count.

Each assignment specifies a goal, workspace, ownership, relevant evidence, acceptance checks, limits, and a compact return format. The coordinator remains responsible for the integrated result. Workers return precise file/line references, actual check outcomes, and unresolved uncertainty rather than full logs or progress narration.

## Context and token discipline

- Search for named symbols or behavior first; expand only as evidence requires.
- Pass the minimum context needed for the task. Prefer paths, line references, contracts, and focused diffs over copying whole files or logs.
- Keep original evidence available. Summaries help navigate; they do not replace source, diffs, exact errors, or test results. Reopen evidence when a summary is ambiguous.
- Avoid repeated reads, duplicate investigations, and frequent polling. Use completion notification or a wait mechanism when the host supports it.
- Preserve failures, caveats, and verification detail. Correctness takes priority over shorter output.
- Concise wording mainly affects output tokens; it does not remove input or reasoning cost. Measure total usage before claiming a saving.

These practices adapt useful ideas from Cavecrew/Caveman and other public Codex orchestration projects. `duet` does not load or require those projects or their skills at runtime.

## Install

Copy this skill folder to a Codex skill directory:

```text
~/.codex/skills/duet/
```

Expected contents:

```text
duet/
├── SKILL.md
├── README.md
├── README.zh-CN.md
├── models.json
├── agents/openai.yaml
└── references/cost-and-sources.md
```

Refresh or restart Codex if it does not appear in the skill picker.

## Use

Choose GPT-6 Astra for the root session if it should coordinate, then invoke:

```text
$duet Implement this feature. Delegate bounded work to GPT-6.1 Sol agents where useful, then verify the integrated result.
```

The skill cannot change the model of an already-running root session. It checks whether the host exposes the configured worker model and can select a per-agent model. It reports incompatibility rather than silently substituting a model.

## Configure models

Change `models.json` to set defaults:

```json
{
  "coordinator_model": "gpt-6-astra",
  "worker_model": "gpt-6.1-sol"
}
```

Use IDs supported by the active host. A task-level user choice overrides the defaults for that task without rewriting the file.

These values select models only. They do not configure credentials, choose API versus subscription billing, or guarantee a billing route. Confirm provider routing and usage in the host's account and usage tools.

## Cost model

For comparable accepted work, include coordinator and worker input, cached input, output/reasoning, tool results, integration, and retries. Compare quality and rework along with usage. If Sol is cheaper for a token class, moving suitable work to Sol reduces the direct charge for that class at comparable volume; whether the whole workflow saves money depends on repeated context, coordination, and rework. Check each token class and context tier separately, and do not claim measured savings without measurement.

See [`references/cost-and-sources.md`](references/cost-and-sources.md) for the calculation and design references.

## Compatibility

`duet` requires host-native subagent support and availability of configured models. It does not install an orchestration runner, modify global Codex settings, or depend on another skill at runtime. The host creates and meters model sessions.
