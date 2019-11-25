use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mapp_construction, MappConstructionWeb.Endpoint,
  http: [port: 4001],
  server: true

config :mapp_construction, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :mapp_construction, MappConstruction.Repo,
  username: "postgres",
  password: "postgres",
  database: "mapp_construction_test",
  hostname: "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool: Ecto.Adapters.SQL.Sandbox,
  types: MappConstruction.PostgresTypes

config :mapp_construction, MappConstruction.Mailer, adapter: Bamboo.TestAdapter

config :mapp_construction,
  s3_signer: MappConstruction.S3Signer.Mock

  config :hound,
  driver: "selenium",
  browser: "chrome",
  app_port: 4001,
  genserver_timeout: 480_000

config :cabbage,
  features: "test/integration/feature_files/"
