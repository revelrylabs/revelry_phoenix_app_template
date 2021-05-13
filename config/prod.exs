use Mix.Config
# NOTE: Compile-time production configuration goes here

config :app_template, AppTemplateWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true,
  root: ".",
  version: Application.spec(:app_template, :vsn)

config :app_template, AppTemplate.Repo,
  database: "postgres",
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: "app-template-database",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Do not print debug messages in production
config :logger, level: :info

config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
       domain: System.get_env("AUTH0_DOMAIN"),
       client_id: System.get_env("AUTH0_CLIENT_ID"),
       client_secret: System.get_env("AUTH0_CLIENT_SECRET")

config :guardian, Guardian,
       issuer: System.get_env("AUTH0_DOMAIN"),
       secret_key: System.get_env("AUTH0_CLIENT_SECRET")

config :rollbax,
  client_token: System.get_env("ROLLBAR_CLIENT_TOKEN"),
  access_token: System.get_env("ROLLBAR_SERVER_TOKEN"),
  environment: System.get_env("ROLLBAR_ENVIRONMENT"),
  enabled: true,
  enable_crash_reports: true,
  reporters: [AppTemplate.RollbaxReporter]

config :app_template, AppTemplate.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")
