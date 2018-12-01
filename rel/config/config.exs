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
