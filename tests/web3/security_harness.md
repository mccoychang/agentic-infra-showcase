# Test Harness: Secure Master-Guardian Bridge

This document showcases our testing methodology for high-security agent components.

## Scenario 1: Daily Limit Enforcement
**Objective**: Ensure the Guardian correctly intercepts a sequence of transactions that cumulatively exceed the daily allowance.

```python
def test_cumulative_limit_interception():
    guardian = GuardianSigner(limit=1.0) # 1 ETH
    
    # Tx 1: 0.8 ETH (Allowed)
    assert guardian.sign({"value": 0.8e18, "to": "0x..."})['status'] == 'success'
    
    # Tx 2: 0.3 ETH (Blocked - cumulative 1.1 ETH)
    result = guardian.sign({"value": 0.3e18, "to": "0x..."})
    assert result['status'] == 'error'
    assert "limit exceeded" in result['message'].lower()
```

## Scenario 2: Whitelist Bypass Attempt
**Objective**: Verify that even if the Master is compromised, the Guardian blocks non-whitelisted destinations.

```python
def test_unauthorized_destination_blocking():
    guardian = GuardianSigner(whitelist=["0xTRUSTED"])
    
    # Compromised Master tries to send to attacker
    result = guardian.sign({"value": 0.1e18, "to": "0xATTACKER"})
    assert result['status'] == 'error'
```

---
*Production tests include asynchronous race-condition checking and signature replay protection.*
