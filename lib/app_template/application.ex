defmodule AppTemplate.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    setup()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: AppTemplate.PubSub},
      # Start the Ecto repository
      AppTemplate.Repo,
      # Start the Telemetry
      AppTemplate.Telemetry,
      # Start the endpoint when the application starts
      AppTemplateWeb.Endpoint,
      # Start your own worker by calling: AppTemplate.Worker.start_link(arg1, arg2, arg3)
      # worker(AppTemplate.Worker, [arg1, arg2, arg3]),
      {Cluster.Supervisor, [cluster_topologies(), [name: AppTemplate.ClusterSupervisor]]}
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

  defp cluster_topologies do
    enabled = Application.get_env(:app_template, :cluster_enabled)
    topologies = Application.get_env(:app_template, :cluster_topologies)

    if enabled, do: topologies, else: []
  end

  defp setup do
    AppTemplateWeb.PipelineInstrumenter.setup()
    AppTemplateWeb.Repo.Instrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    AppTemplateWeb.MetricsExporter.setup()

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [:app_template, :repo, :query],
        &AppTemplateWeb.Repo.Instrumenter.handle_event/4,
        %{}
      )
  end
end
