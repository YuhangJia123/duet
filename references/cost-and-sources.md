# Cost evaluation and design sources

## Measurement

Compare accepted changes of similar difficulty: single Astra versus Astra + Sol.
Include the root and every worker, actual provider prices, cache rates, reasoning
tokens (without double counting them if already in output), tools, failures and
retries. Record elapsed time and acceptance outcomes alongside cost. Do not run
paid benchmark jobs just to demonstrate the skill unless the task authorizes them.

Let baseline Astra cost be C, migrated cost-weighted share f, effective Sol/Astra
price ratio r, and extra coordination/rework cost H. With equivalent token mixes:

    grouped cost ≈ C × ((1 − f) + r × f) + H
    savings require H < C × f × (1 − r)

For any user-supplied Astra/Sol price ratio, calculate r separately for input,
cached input, output and any long-context tier. Do not assume the ratio is identical
across token classes or context tiers. If the ratio is stable and token volume and
quality stay comparable, moving suitable execution to the cheaper model lowers its
direct model charge; total savings still depend on H and the actual workload. This
is an algebraic consequence of the supplied ratio, not a benchmark of this skill.

Subscription quota consumption and API currency costs are separate metrics.
Do not assign a fixed token/week capacity to Pro or presume separate worker billing.

## Design sources

Original synthesis; no upstream installer or code copied or executed.

- https://github.com/donvito/codex-astra-luna-orchestrator
  README: coordinator/execution role split, explicit per-role models, usage measurement.
  Its default Luna executors and independent reviewer are not required by duet.
- https://github.com/TemMax/agent-skills
  README: bounded contracts, file-independent work waves and evidence-based supervision.
  Its full runner, automatic PR pipeline and per-task worktrees are not adopted.
- Local cavecrew SKILL.md: compact investigator, builder and reviewer handoffs.
  Claude/Haiku presets and terse style are not inherited; duet verifies behavior.
- https://github.com/JuliusBrussee/caveman/tree/main/skills/cavecrew
  Role-specific bounded work and compact evidence contracts; no universal savings rate.
- https://github.com/JuliusBrussee/caveman/tree/main/engine
  Reversible tool-output compression and fallback when parsing or reduction fails.
- https://github.com/JuliusBrussee/caveman/blob/main/docs/HONEST-NUMBERS.md
  Output style alone does not reduce input/reasoning; benchmark claims need controls.
- https://github.com/JuliusBrussee/caveman/blob/main/docs/technical/learn.md
  Measure actual token sinks before choosing an optimization.
- https://github.com/douglasmonsky/codex-orchestrate
  Compact task context, recovery, model routing, and coordinator integration.
- https://github.com/JashinYang/codex-multi-model-orchestrator
  Runtime model availability, task ownership, dependency-aware batches, and acceptance.
- https://github.com/FBisca/agent-skills
  Small collaborator sets and deterministic verification gates.
- https://github.com/Concrete333/Codex-Delegation-Deployment
  Bounded delegation and avoiding repeated polling; inspect license before copying code.
- https://github.com/leeeboo/codex-sol-luna-orchestrator
  Per-role model configuration and concurrency profiles.
- https://github.com/ZypherHQ/agent-orchestration-skill
  Usage ledger concepts; the full CLI/dashboard is intentionally not a dependency.
- https://github.com/notorious-d-e-v/agent-skills/tree/main/skills/astra-sol-delegation
  Specific Astra-to-Sol role split and the boundary between delegation and host support.
- https://github.com/delatran/codex-nexus/tree/main/skills/astra-orchestration
  Deliverables, ownership, acceptance checks, and single-agent routing when parallelism adds no value.
- https://github.com/scdenney/open-science-skills/tree/main/codex
  Codex skill catalog and model-pair orchestration examples; model aliases remain host-dependent.
- https://learn.chatgpt.com/docs/agent-configuration/subagents
  Native subagents and configurable role models. Actual runtime tool schemas take
  precedence over examples; this skill does not install a global model configuration.
