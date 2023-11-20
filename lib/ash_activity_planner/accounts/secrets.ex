defmodule AshActivityPlanner.Accounts.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], AshActivityPlanner.Accounts.User, _) do
    case Application.fetch_env(:ash_activity_planner, AshActivityPlannerWeb.Endpoint) do
      {:ok, endpoint_config} ->
        Keyword.fetch(endpoint_config, :secret_key_base)

      :error ->
        :error
    end
  end
end
