use Mix.Config
# NOTE: Runtime production configuration goes here

config :app_template, AppTemplate.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

port = String.to_integer(System.get_env("PORT"))

config :app_template, AppTemplateWeb.Endpoint,
  http: [port: port],
  url: [host: "localhost", port: port],
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :rollbax,
  client_token: System.get_env("ROLLBAR_CLIENT_TOKEN"),
  access_token: System.get_env("ROLLBAR_SERVER_TOKEN"),
  environment: System.get_env("ROLLBAR_ENVIRONMENT"),
  enabled: true

config :app_template, :statix,
  prefix: "app_template",
  host: System.get_env("DATADOG_HOST") || "localhost",
  port: String.to_integer(System.get_env("DATADOG_PORT") || "8125")

config :app_template, AppTemplate.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")
