defmodule McCoyLabs.Web3.SecureAgent do
  @moduledoc """
  Architectural blueprint for a secure agentic transaction flow.
  This module defines the required behaviors for a 'Master' agent that
  requests signatures from an isolated 'Guardian' entity.
  """

  @type tx_payload :: map()
  @type intent_context :: %{
          intent: String.t(),
          timestamp: DateTime.t(),
          security_token: String.t()
        }

  @doc """
  Initializes the secure bridge with the Guardian entity.
  Implementations must ensure an encrypted handshake is established.
  """
  @callback init_secure_bridge(config :: map()) :: {:ok, pid()} | {:error, term()}

  @doc """
  Requests a signature for a transaction payload.
  The Master agent never holds the private key; it only transmits verified intent.
  """
  @callback request_signature(tx_payload(), intent_context()) ::
              {:ok, signed_tx :: String.t()}
              | {:error, :policy_violation}
              | {:error, term()}

  @doc """
  Enforces post-transaction audit logging.
  """
  @callback log_execution(tx_hash :: String.t(), result :: map()) :: :ok

  defmacro __using__(_opts) do
    quote do
      @behaviour McCoyLabs.Web3.SecureAgent
      require Logger

      def execute_secure_flow(tx, context) do
        # Standardized workflow: 
        # 1. Validate intent 
        # 2. Request Guardian signature 
        # 3. Broadcast 
        # 4. Audit
        Logger.info("Starting secure execution flow for intent: #{context.intent}")
      end
    end
  end
end
