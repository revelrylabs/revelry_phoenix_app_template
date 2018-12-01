# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

# General application configuration
config :app_template,
  ecto_repos: [AppTemplate.Repo]

# Configures the endpoint
config :app_template, AppTemplateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ot1FLrZNFgZtCRO1Qm3mPuleg4WZoEZURicyDhj4/Y/++uGBPQBz390gYH3L3Oda",
  render_errors: [view: AppTemplateWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AppTemplate.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
