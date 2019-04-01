use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app_template, AppTemplateWeb.Endpoint,
  http: [port: 4001],
  server: true

config :app_template, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :app_template, AppTemplate.Repo,
  username: "postgres",
  password: "postgres",
  database: "app_template_test",
  hostname: "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool: Ecto.Adapters.SQL.Sandbox,
  types: AppTemplate.PostgresTypes

config :app_template, AppTemplate.Mailer, adapter: Bamboo.TestAdapter

config :app_template,
  s3_signer: AppTemplate.S3Signer.Mock

config :wallaby,
  driver: Wallaby.Experimental.Chrome
