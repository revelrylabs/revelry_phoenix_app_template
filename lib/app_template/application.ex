defmodule MappConstruction.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    setup()

    topologies = Application.get_env(:mapp_construction, :cluster_topologies)

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(MappConstruction.Repo, []),
      # Start the endpoint when the application starts
      supervisor(MappConstructionWeb.Endpoint, []),
      # Start your own worker by calling: MappConstruction.Worker.start_link(arg1, arg2, arg3)
      # worker(MappConstruction.Worker, [arg1, arg2, arg3]),
      {Cluster.Supervisor, [topologies, [name: MappConstruction.ClusterSupervisor]]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MappConstruction.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MappConstructionWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp setup do
    MappConstructionWeb.Phoenix.Instrumenter.setup()
    MappConstructionWeb.PipelineInstrumenter.setup()
    MappConstructionWeb.Repo.Instrumenter.setup()
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    MappConstructionWeb.MetricsExporter.setup()

    :ok =
      :telemetry.attach(
        "prometheus-ecto",
        [:mapp_construction, :repo, :query],
        &MappConstructionWeb.Repo.Instrumenter.handle_event/4,
        %{}
      )
  end
end
