import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ash_activity_planner, AshActivityPlanner.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ash_activity_planner_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ash_activity_planner, AshActivityPlannerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rrjUfUc1DIT+kC7khM/3nSgX+nftUfFukMrB2OpAD6I1BuD4Y6ktoQMYP7KDOsPt",
  server: false

# In test we don't send emails.
config :ash_activity_planner, AshActivityPlanner.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
