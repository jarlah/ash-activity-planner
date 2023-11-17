defmodule AshActivityPlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    if Application.get_env(:testcontainers, :enabled, false) do
      {:ok, _container} =
        Testcontainers.Ecto.postgres_container(
          app: :ash_activity_planner,
          persistent_volume_name: "ash_activity_planner_data"
        )
    end

    children = [
      {AshAuthentication.Supervisor, otp_app: :ash_activity_planner},
      AshActivityPlannerWeb.Telemetry,
      AshActivityPlanner.Repo,
      {DNSCluster,
       query: Application.get_env(:ash_activity_planner, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshActivityPlanner.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AshActivityPlanner.Finch},
      # Start a worker by calling: AshActivityPlanner.Worker.start_link(arg)
      # {AshActivityPlanner.Worker, arg},
      # Start to serve requests, typically the last entry
      AshActivityPlannerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshActivityPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshActivityPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
