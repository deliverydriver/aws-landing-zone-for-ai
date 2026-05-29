# AWS Landing Zone for AI & Agentic Systems — Architecture Overview

## High-Level Structure

```mermaid
graph TB
    subgraph Management["Management Account (Control Tower)"]
        Org[Organizations]
        CT[Control Tower]
    end

    subgraph SecurityOU["Security OU"]
        LogArchive[Log Archive]
        SecurityTooling[Security Tooling<br/>GuardDuty + Security Hub + Macie]
        Audit[Audit Account]
    end

    subgraph PlatformOU["Platform OU"]
        Network[Network Account<br/>Transit Gateway + Centralized Egress + PrivateLink]
        Shared[Shared Services]
    end

    subgraph AIWorkloads["AI Workloads OU"]
        Research[Research Accounts<br/>(Higher autonomy)]
        Production[Production Agent Accounts<br/>(Strict controls)]
        Data[Data & Knowledge Accounts]
    end

    subgraph Sandbox["Sandbox OU"]
        Dev[Individual Dev / Experiment Accounts]
    end

    Org --> SecurityOU
    Org --> PlatformOU
    Org --> AIWorkloads
    Org --> Sandbox

    Research -.->|PrivateLink + SCPs| Network
    Production -.->|PrivateLink + Strict SCPs| Network
    Production -.->|Tool calls via Approval Proxy| Production
```

## Key Design Principles

- **Research vs Production isolation** is the primary OU boundary
- **Cost attribution** must work at the agent/experiment level, not just the account level
- **Tool calling** between accounts is heavily restricted and usually goes through an approval proxy layer
- **PrivateLink first** for all model and tool access where possible

## Next

See individual ADRs in `docs/adrs/` for the reasoning behind major decisions (SCP strategy, networking model, KMS approach, etc.).
