defmodule Mix.Tasks.MappConstruction.GrantAdmin do
  use Mix.Task

  alias MappConstruction.{ReleaseTasks}

  @shortdoc "Grants the given user admin access"

  @moduledoc """
  Grants the given user admin access

  usage:

  mix mapp_construction.grant_admin <email>
  """

  @doc false
  def run([email]) do
    Mix.Task.run("app.start")
    ReleaseTasks.grant_admin_permissions(email)
  end
end
