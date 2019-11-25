defmodule Mix.Tasks.MappConstruction.RevokeAdmin do
  use Mix.Task

  alias MappConstruction.{ReleaseTasks}

  @shortdoc "Revokes the given user admin access"

  @moduledoc """
  Revokes the given user admin access

  usage:

  mix mapp_construction.revoke_admin <email>
  """

  @doc false
  def run([email]) do
    Mix.Task.run("app.start")
    ReleaseTasks.revoke_admin_access(email)
  end
end
