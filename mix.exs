defmodule AppTemplate.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app_template,
      version: System.get_env("APP_VERSION") || "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AppTemplate.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0-rc", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto_sql, "~> 3.0-rc"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.2.0-rc.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:credo, "~> 1.0", only: :dev},
      {:excoveralls, "~> 0.7", only: :test},
      {:comeonin, "~> 5.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:harmonium, "~> 2.0.0"},
      {:distillery, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:rollbax, "~> 0.9"},
      {:vmstats, "~> 2.3"},
      {:statix, "~> 1.1"},
      {:bamboo, "~> 1.2.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_machina, "~> 2.2", only: :test},
      {:stream_data, "~> 0.4.2", only: :test},
      {:joken, "~> 2.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:transmit, "~> 0.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      compile: ["compile --warnings-as-errors"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
