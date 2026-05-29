# Terraform for AWS Multi-Account Landing Zone (AI-focused)

This directory contains the Infrastructure as Code for the landing zone described in the root README.

## Goals

- Strong, opinionated defaults for AI and agentic workloads
- Clear separation between Research and Production Agents
- Excellent cost attribution and security guardrails
- GitOps-friendly and testable

## Structure

```
terraform/
├── modules/
│   ├── account-baseline/          # Common baseline for every account
│   ├── scp-library/               # Reusable SCPs as code
│   ├── tagging-enforcement/       # Tag policies + enforcement
│   └── network-baseline/          # Centralized networking patterns
├── examples/
│   └── landing-zone/              # Full example composition
└── README.md
```

## Usage

See `examples/landing-zone` for a complete runnable example.

## Philosophy

We treat SCPs and account baselines as **code**, not one-off console actions. Every policy has an accompanying ADR explaining the intent.