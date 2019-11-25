# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

# General application configuration
config :mapp_construction,
  ecto_repos: [MappConstruction.Repo]

# Configures the endpoint
config :mapp_construction, MappConstructionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ot1FLrZNFgZtCRO1Qm3mPuleg4WZoEZURicyDhj4/Y/++uGBPQBz390gYH3L3Oda",
  render_errors: [view: MappConstructionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MappConstruction.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [MappConstructionWeb.Phoenix.Instrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rollbax,
  enabled: false,
  environment: "dev"

config :mapp_construction, MappConstruction.Mailer, adapter: Bamboo.LocalAdapter

config :bamboo, :json_library, Jason

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :mapp_construction, jwt_secret: "secret"

# see releases.exs for production config
config :mapp_construction, cluster_topologies: []

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
