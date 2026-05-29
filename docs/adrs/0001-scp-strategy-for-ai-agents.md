# ADR 0001: Service Control Policy Strategy for AI and Agentic Workloads

**Status**: Proposed (to be refined as we implement and operate)

**Date**: 2026-05-29

## Context

We are building a multi-account landing zone that must support two very different classes of AI workload:

- High-velocity research and experimentation agents (need significant freedom to call models and tools).
- Production customer-facing agents (voice platforms, tool-using autonomous systems) that require strong guardrails around cost, security, and blast radius.

Standard enterprise SCP strategies (mostly "deny everything dangerous and allow the rest") do not work well here. AI agents routinely need to invoke models (Bedrock, SageMaker), execute code/tools, access data stores, and in some cases cross account boundaries — all while we still need to prevent catastrophic mistakes (runaway spend, data exfiltration, privilege escalation via tool use).

## Decision

We will use a layered, capability-based SCP strategy rather than simple allow/deny lists:

1. **Baseline Deny List** (applies everywhere)
   - Block high-risk actions that are almost never legitimate for agents (e.g., `organizations:*`, most IAM root actions, broad S3 public access changes, etc.).
   - Explicitly deny certain high-cost or high-risk Bedrock/SageMaker actions unless explicitly excepted.

2. **Capability-Based Allow Lists per OU**
   - Research OU: Relatively permissive model invocation + tool execution, but with hard spend caps via budgets + SCP conditions where possible, plus mandatory tagging.
   - Production Agents OU: Much tighter — model invocation only through approved Bedrock Agents/Guardrails configurations, tool calling only through explicitly approved tool server accounts via PrivateLink + specific IAM conditions.
   - Data & Knowledge OU: Focused on read-heavy access with strong encryption and logging requirements.

3. **Cross-Account Tool Calling Controls**
   - Agents in one account may only call tools in another account via explicitly allowed PrivateLink connections + SCP conditions that require specific resource tags and source account conditions.
   - No broad `sts:AssumeRole` or cross-account access for agent execution roles.

4. **Exception Process**
   - Any broadening of SCPs requires a documented exception (stored in this repo), time-bound where possible, with compensating controls (extra logging, tighter budgets, manual approval gates, etc.).

## Consequences

**Positive**
- Much better alignment with how agents actually behave (they need model + tool freedom within bounded contexts).
- Strong defense-in-depth when combined with the approval proxy layer in the agent platform.
- Clear, auditable boundary between "research can experiment" and "production must be safe".
- Forces explicit thinking about tool capabilities rather than vague "least privilege."

**Negative / Trade-offs**
- SCPs become more complex and harder to reason about at a glance.
- Exception process adds operational overhead (this is intentional).
- Some legitimate early experimentation may be slowed down until exception is granted.

**Alternatives Considered**
- Pure "deny list only" approach: Rejected. Too easy for agents to do expensive or dangerous things within the allowed surface.
- Per-account SCPs instead of OU-level: Rejected. Too much duplication and drift risk.
- Relying only on IAM policies and the agent platform approval layer: Insufficient. SCPs are the only control that cannot be bypassed by a compromised or misbehaving execution role in the account.

## Implementation Notes

- SCPs will be managed as code (JSON + Terraform) in this repository.
- We will maintain a "capability catalog" that maps common agent tool patterns to the minimum SCP grants required.
- Regular reviews of SCP effectiveness will be driven by real agent behavior logs and cost data.

## Related Decisions

- ADR 0002 (future): Workload Identity and Cross-Account Tool Execution Model
- Patterns in aws-agent-platform for approval proxies and tool server boundaries
- Cost guardrails and anomaly detection in the landing zone

---

This decision will be revisited after we have 3–6 months of real production agent behavior data.