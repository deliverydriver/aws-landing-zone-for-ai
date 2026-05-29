# AWS Multi-Account Landing Zone for AI & Agentic Workloads

**A production-grade, opinionated multi-account foundation on AWS, specifically designed for long-running autonomous agents, voice systems, research workloads, and sovereign AI infrastructure.**

This is a **living project** that will be continuously updated as I progress through the AWS Certified Solutions Architect – Professional exam and build real production agent platforms.

## Why This Project Matters (For Exams + Career)

In almost every serious Solutions Architect interview (especially at senior/lead/consulting level), you will be asked:

- "How would you design a multi-account strategy?"
- "How do you handle security and governance at scale?"
- "How would you isolate different workloads (e.g. research agents vs production customer-facing agents)?"

This project gives you a concrete, battle-tested answer — and one that is differentiated because it is built for the emerging world of **agentic AI systems** rather than generic web apps.

### AWS Certified Solutions Architect – Professional Exam Coverage

This project directly maps to multiple domains:

| Exam Domain | How This Project Demonstrates Mastery |
|-------------|---------------------------------------|
| Design for organizational complexity | Full OU structure, SCPs, IAM Identity Center, cross-account access patterns |
| Design for security & compliance | Least privilege at scale, service control policies, KMS strategies, logging/monitoring baseline |
| Design for new solutions | Landing zone as the foundation for migrating/building AI platforms |
| Design for reliability & operational excellence | Standardized account baselines, tagging, backup, observability |
| Design for cost optimization | Chargeback/showback design, Savings Plans strategy per workload type |

## Target Architecture (Living)

**High-level structure (will evolve):**

```
Management Account (Control Tower)
├── Security OU
│   ├── Log Archive
│   ├── Security Tooling (GuardDuty, Security Hub, Inspector, etc.)
│   └── Audit
├── Infrastructure OU
│   ├── Network Account (Transit Gateway, VPCs, PrivateLink, etc.)
│   └── Shared Services
├── AI Workloads OU
│   ├── Research & Experimentation (high autonomy, lower guardrails)
│   ├── Production Agents (voice platforms, long-running agents, customer workloads)
│   └── Data & Knowledge Platforms (RAG, vector stores, etc.)
├── Sandbox OU
│   └── Individual developer / agent research accounts
└── Suspended / Deprecated
```

Key design decisions we will document and refine over time:
- When to use Control Tower vs custom landing zone
- SCP strategy for AI workloads (Bedrock, SageMaker, Lambda, ECS, etc.)
- IAM Identity Center permission sets for different personas (AI Engineer, Platform, Auditor, Emergency)
- Networking model (centralized egress, PrivateLink for AI services, Transit Gateway segmentation)
- Encryption and key management strategy (customer-managed KMS keys per OU)
- Observability and cost allocation tags that actually work for agent runs

## Current Status

**Phase 0 – Foundation (Current)**
- [x] Repository created with strong initial documentation
- [ ] Control Tower deployment runbook (manual + automated)
- [ ] Core OU + account structure (as code)
- [ ] Baseline SCPs for AI workloads
- [ ] IAM Identity Center baseline

**Phase 1 – Governance & Security**
- Service Control Policies tailored for agentic workloads
- AWS Config rules + remediation for AI resources
- Centralized logging and Security Hub aggregation
- Backup and DR strategy for stateful agents

**Phase 2 – AI-Specific Patterns**
- Patterns for secure tool use from agents
- Cost controls and budgets for LLM spend
- Private connectivity to Bedrock / SageMaker endpoints
- Workload isolation between research and production agents

**Phase 3 – Automation & GitOps**
- Full Infrastructure as Code (Terraform or CDK)
- Account vending machine / account factory customizations
- CI/CD for landing zone changes
- Self-service account provisioning with guardrails

## Technology Choices (Will Be Justified Over Time)

- **Infrastructure as Code**: Terraform (primary) + possibly AWS CDK for specific AI constructs
- **Landing Zone Engine**: AWS Control Tower + customizations (or pure custom if needed)
- **Identity**: IAM Identity Center (SSO)
- **Networking**: Transit Gateway + VPC Lattice where appropriate
- **Security**: KMS, GuardDuty, Security Hub, IAM Access Analyzer, Detective
- **Observability**: CloudWatch + X-Ray + OpenTelemetry for agent runs

## How to Use This Repository

This is not a "deploy and forget" template. It is a **reference implementation + living decision log**.

Each major decision will have an ADR (Architecture Decision Record) in `/docs/adrs/`.

When I apply for Solutions Architect roles or consulting engagements, this repo (plus the other projects in the portfolio) becomes the concrete evidence of deep, practical experience.

## Related Living Projects

This landing zone is the foundation for the rest of the portfolio:

- [aws-agent-platform](../aws-agent-platform) — The actual production runtime for voice-controlled and autonomous agents
- [aws-well-architected-ai](../aws-well-architected-ai) — Reference architectures + full Well-Architected reviews
- [aws-sovereign-infrastructure](../aws-sovereign-infrastructure) — Highly restricted patterns for sensitive clients

## Getting Started (Local)

```bash
git clone https://github.com/YOUR_USERNAME/aws-landing-zone-for-ai
cd aws-landing-zone-for-ai

# (Coming soon) Terraform setup + Control Tower bootstrap scripts
```

## Contributing / Evolution

This project will be updated publicly as I study and build. Feedback, issues, and PRs that improve the architecture (especially around AI/agent workloads) are welcome.

---

**Goal**: By the time I sit the AWS Solutions Architect Professional exam, this repository + the others in the portfolio should be strong enough that any interviewer can see: "This person doesn't just know the theory — they are actively building and operating real systems at this level of sophistication."

Built by Benjamin Pittman (Spacecoast) while preparing for the AWS Certified Solutions Architect – Professional exam.
