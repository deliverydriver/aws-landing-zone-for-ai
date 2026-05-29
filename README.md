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

Further reading in the sibling repositories covers the actual agent runtime, reference architectures under operational review, and patterns for more restricted environments.