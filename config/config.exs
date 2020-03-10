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
  pubsub: [name: AppTemplate.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [AppTemplateWeb.Phoenix.Instrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rollbax,
  enabled: false,
  environment: "dev"

config :app_template, AppTemplate.Mailer, adapter: Bamboo.LocalAdapter

config :bamboo, :json_library, Jason

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :app_template, jwt_secret: "secret"

# see releases.exs for production config
config :app_template, cluster_topologies: []

config :app_template, email: {"AppTemplate", "noreply@app_template.org"}

config :app_template, :pow,
  user: AppTemplate.User,
  repo: AppTemplate.Repo,
  web_module: AppTemplateWeb,
  mailer_backend: AppTemplate.Mailer,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_mailer_module: AppTemplateWeb

config :app_template, ExOauth2Provider,
  repo: AppTemplate.Repo,
  resource_owner: AppTemplate.User,
  password_auth: {AppTemplate.OAuthPasswordGrant, :authenticate},
  use_refresh_token: true,
  default_scopes: ~w(public),
  optional_scopes: ~w(read write)

config :app_template,
       PhoenixOauth2Provider,
       web_module: AppTemplateWeb,
       current_resource_owner: :current_user

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config("#{Mix.env()}.exs")
