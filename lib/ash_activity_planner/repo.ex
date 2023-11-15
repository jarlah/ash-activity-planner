defmodule AshActivityPlanner.Repo do
  use AshPostgres.Repo, otp_app: :ash_activity_planner

  # Installs Postgres extensions that ash commonly uses
  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
