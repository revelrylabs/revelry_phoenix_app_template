defmodule AppTemplate.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    statix_config = Application.get_env(:app_template, :statix)
    Application.put_env(:statix, AppTemplate.Statix, statix_config)
    :ok = AppTemplate.Statix.connect()

    Telemetry.attach(
      "record_ecto_metric",
      [:app_template, :repo, :query],
      AppTemplate.Metrics,
      :record_ecto_metric,
      nil
    )

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(AppTemplate.Repo, []),
      # Start the endpoint when the application starts
      supervisor(AppTemplateWeb.Endpoint, [])
      # Start your own worker by calling: AppTemplate.Worker.start_link(arg1, arg2, arg3)
      # worker(AppTemplate.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AppTemplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AppTemplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
