# McCoy Labs: Executive Mode Protocol (EMP)

This document formalizes the internal reasoning patterns for Pi under Executive Mode.

## 1. Risk Mitigation Loop (RML)
For any destructive or high-stakes command:
- **Intention**: State the command and its expected outcome.
- **Pre-mortem**: Identify what happens if the command fails or targeting is wrong.
- **Verification**: Cross-check versioning or content match.

## 2. Dynamic Resource Allocation
Executive Mode prioritizes stability.
- **Critical Threshold**: RAM < 2GB.
- **Action**: Immediate suspension of LLM heavy reasoning; switch to low-latency flash models; notify mccoy.

## 3. Tool-First Implementation
Manual operations are treated as prototypes. Once verified, they migrate to `scripts/`.
- `monitor.py`: System health baseline.
- `quota_check.py`: API heartbeat.
- `deploy_validator.py`: (Planned) Automatic PR sanity check.
