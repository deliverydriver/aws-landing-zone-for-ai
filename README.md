# Multi-Account Landing Zone for AI & Agentic Workloads

A production-grade, opinionated multi-account foundation on AWS designed for long-running autonomous agents, voice systems, research workloads, and sovereign AI infrastructure.

## Problems This Addresses

Standard multi-account strategies assume relatively stateless, request-oriented workloads. AI and agentic systems introduce different pressures:

- Long-running stateful processes that need consistent identity, memory, and tool access over hours or days
- Highly variable and unpredictable spend from model inference and tool use
- The need to isolate exploratory/research agents from production customer-facing agents without losing the ability to share common data planes
- Security boundaries around tool execution that are more nuanced than typical service-to-service access
- Cost attribution that must survive agent delegation and multi-turn workflows

This repository documents the account structure, governance controls, networking model, and baseline services required to operate under those conditions.

## Current Target Structure

```
Management
├── Security OU
│   ├── Log Archive
│   ├── Security Tooling
│   └── Audit
├── Platform OU
│   ├── Network (Transit Gateway, central egress, PrivateLink endpoints)
│   └── Shared Services (identity, CI/CD, observability)
├── AI Workloads OU
│   ├── Research (higher autonomy, aggressive experimentation guardrails)
│   ├── Production Agents (voice platforms, customer workloads, strict change control)
│   └── Data & Knowledge (RAG stores, vector indexes, curated corpora)
└── Sandbox
```

Key decisions being worked through:

- Scope and granularity of Service Control Policies for Bedrock, SageMaker, Lambda, ECS, and tool-calling surfaces
- IAM Identity Center permission sets that reflect actual operational personas (agent operator, platform engineer, incident responder, auditor)
- Networking model that supports both centralized control and the low-latency/private connectivity patterns agents often require
- Encryption and key management strategy that scales across dozens of accounts while supporting customer-managed keys for sensitive agent memory and tool outputs
- Tagging and cost allocation model that can attribute spend to individual agents, customers, or experiments rather than just accounts

## Status and Direction

The repository is in active development. Current focus is on the foundational controls and account vending patterns. Subsequent work will cover:

- AI-specific SCP libraries and exception handling processes
- Workload identity patterns for agents that need to act across accounts
- Cost guardrails and anomaly detection tuned for inference spend
- Integration points with the agent runtime platform (see aws-agent-platform)

All major structural decisions are captured as ADRs as they are made.

## Context

This work sits alongside production agent systems already running in more constrained environments. The goal is a landing zone that supports both high-velocity research and regulated production workloads without requiring completely separate foundations.

---

## Services and Patterns for Demonstrating Depth

To credibly signal extensive hands-on experience, this project will incorporate sophisticated, production-grade usage of the following AWS capabilities (not superficial mentions, but real architectural integration with the AI/agentic constraints):

**Governance & Organizations**
- AWS Organizations with delegated administrator models for Security Hub, GuardDuty, Config, etc.
- Advanced Service Control Policies (SCPs) with AI-specific restrictions (e.g., Bedrock model filtering, SageMaker instance type controls, cross-account tool invocation boundaries, Lambda layer and execution role constraints).
- IAM Identity Center with ABAC, permission boundaries, and persona-specific permission sets (agent operator vs platform engineer vs emergency access).
- AWS Control Tower with Account Factory for Terraform (AFT) or equivalent custom landing zone automation, including strong baseline enforcement and exception workflows.

**Networking & Connectivity (Deep)**
- Transit Gateway with complex routing tables, peering attachments, and centralized inspection via Gateway Load Balancer + third-party appliances.
- Extensive use of VPC endpoints / PrivateLink for Bedrock, SageMaker, and internal agent tool services across accounts.
- Centralized egress architectures with inspection, advanced NAT strategies, and support for the low-latency private connectivity that voice and real-time agent workloads often require.
- VPC Lattice for service-to-service connectivity with fine-grained auth between research and production agent environments.

**Security & Compliance at Scale**
- Customer-managed KMS keys with complex key policies, grants, automatic rotation, and multi-region replication strategies tailored to agent memory and tool output sensitivity.
- AWS Config with custom rules and conformance packs specifically for AI resources and agent tool servers.
- Full Security Hub + GuardDuty + Inspector + Macie + Detective aggregation, with custom insights and automated response for agent-related findings.
- Organization-level CloudTrail + CloudTrail Lake for deep auditing of agent actions and cross-account tool use.
- IAM Access Analyzer at organization scale for external access and unused access findings.

**Cost & FinOps (Agent-Specific)**
- AWS Cost and Usage Report (CUR) 2.0 + Athena + QuickSight (or custom tooling) for attribution down to individual agent sessions or experiments.
- AWS Budgets combined with anomaly detection and Lambda-based remediation tuned for inference spend volatility.
- Savings Plans, Spot, and Graviton strategies documented per workload type (research vs production agents).
- Tagging strategies and enforcement that survive agent delegation and multi-turn workflows.

**Observability & Operations**
- Centralized observability (CloudWatch + X-Ray + OpenTelemetry) with cross-account visibility for agent platforms.
- AWS Systems Manager for baseline configuration, patching, and drift detection across the estate.
- Custom operational dashboards that surface "agent platform health" metrics at the landing zone level.

These will be implemented via reusable Terraform modules, with detailed ADRs explaining the choices, and real (anonymized where necessary) examples of policy, tagging, and cost models that only experienced practitioners typically produce.

Further reading in the sibling repositories covers the actual agent runtime, reference architectures under operational review, and patterns for more restricted environments.