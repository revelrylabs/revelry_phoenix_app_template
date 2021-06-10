defmodule AppTemplate.Telemetry do
  @moduledoc """
    This module is used to gain metrics data using Telemetry. It provides a view of the system's behavior over time.
    Here is a [link](https://hexdocs.pm/telemetry_metrics/Telemetry.Metrics.html) to the Telemetry Metrics Docs.
  """
  use Supervisor

  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true

  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      summary("phoenix.endpoint.stop.duration", unit: {:native, :millisecond}),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics

      summary("app_template.repo.query.total_time", unit: {:native, :millisecond}),
      summary("app_template.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("app_template.repo.query.query_time", unit: {:native, :millisecond}),
      summary("app_template.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("app_template.repo.query.idle_time", unit: {:native, :millisecond}),

      # VM Metrics

      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    []
  end
end
