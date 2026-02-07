# McCoy Labs Open Toolkit: Utility Collection

This directory contains lightweight, general-purpose utility scripts and patterns from our labs. These are designed to be immediate, standalone solutions for common development friction points. 

License: MIT (Free to use, modify, and distribute)

---

## 🛠️ featured Tool: Intelligent Log Sanitizer

A common pain point in modern CI/CD and local development is the exposure of sensitive data (API Keys, private tokens) in logs. This script provides a lightweight, regex-driven sanitizer that can be piped into any logging process.

### Implementation (Python)

```python
import re
import sys

def sanitize_logs(stream):
    """
    Sanitizes common sensitive patterns from log streams.
    Usage: tail -f app.log | python3 sanitizer.py
    """
    patterns = {
        'ETH_PRIVATE_KEY': r'0x[a-fA-F0-9]{64}',
        'GENERIC_API_KEY': r'api[-_]?[kK]ey[:\s=]+[a-zA-Z0-9]{32,}',
        'JWT_TOKEN': r'eyJh[a-zA-Z0-9._-]{50,}',
        'BASIC_AUTH': r'Basic\s[a-zA-Z0-9+/=]{20,}'
    }
    
    try:
        for line in stream:
            sanitized_line = line
            for label, pattern in patterns.items():
                sanitized_line = re.sub(pattern, f"<{label}_REDACTED>", sanitized_line)
            sys.stdout.write(sanitized_line)
            sys.stdout.flush()
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    sanitize_logs(sys.stdin)
```

---

## 🏗️ Architectural Pattern: The "Sentinel" Wrapper

A reusable pattern for wrapping unreliable external API calls with automatic retry and exponential backoff, without adding heavy dependencies.

### Implementation (Elixir)

```elixir
defmodule McCoyLabs.Utils.Sentinel do
  @doc \"\"\"
  Wraps a function call with retry logic.
  Example: Sentinel.with_retry(fn -> ExternalAPI.call() end)
  \"\"\"
  def with_retry(func, retries \\ 3, delay \\ 1000) do
    case func.() do
      {:ok, result} -> {:ok, result}
      {:error, reason} when retries > 0 ->
        :timer.sleep(delay)
        with_retry(func, retries - 1, delay * 2)
      {:error, reason} -> {:error, reason}
    end
  end
end
```

---
*More utilities are added periodically as we refine our internal workflows.*
