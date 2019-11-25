use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :mapp_construction, MappConstructionWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    npm: [
      "run",
      "build",
      "--",
      "--watch-stdin",
      "--progress",
      "--color",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :mapp_construction, MappConstructionWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/mapp_construction_web/views/.*(ex)$},
      ~r{lib/mapp_construction_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :mapp_construction, MappConstruction.Repo,
  username: "postgres",
  password: "postgres",
  database: "mapp_construction_dev",
  hostname: "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool_size: 10,
  types: MappConstruction.PostgresTypes

config :mapp_construction, MappConstruction.Mailer, adapter: Bamboo.LocalAdapter

if File.exists?(Path.join([__DIR__, "dev.secret.exs"])) do
  import_config "dev.secret.exs"
end
