defmodule AppTemplate.Metrics do
  @moduledoc false
  alias AppTemplate.Statix
  require Logger
  @behaviour :vmstats_sink
  def collect(_type, name, value) do
    try do
      Statix.gauge(IO.iodata_to_binary(name), value, tags: Statix.base_tags())
    rescue
      ArgumentError ->
        nil
    catch
      :exit, _value ->
        nil
    end
  end

  def record_ecto_metric([:app_template, :repo, :query], _latency, entry, _config) do
    try do
      tags =
        Statix.base_tags() ++
          [
            "query:#{entry.query}",
            "table:#{entry.source}"
          ]

      queue_time = entry.queue_time || 0
      duration = entry.query_time + queue_time

      Statix.increment(
        "ecto.query.count",
        1,
        tags: tags
      )

      Statix.histogram("ecto.query.exec.time", duration, tags: tags)
      Statix.histogram("ecto.query.queue.time", queue_time, tags: tags)
    rescue
      ArgumentError ->
        nil
    catch
      :exit, _value ->
        nil
    end
  end
end
