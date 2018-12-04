defmodule AppTemplate.Statix do
  @moduledoc false
  use Statix, runtime_config: true

  def base_tags do
    {hostname, 0} = System.cmd("hostname", [])
    hostname = String.replace(hostname, "\n", "")

    [
      "app:app_template",
      "pod_name:#{hostname}"
    ]
  end
end