defmodule AppTemplateWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      alias AppTemplateWeb.Router.Helpers, as: Routes
      import AppTemplate.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppTemplate.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AppTemplate.Repo, {:shared, self()})
    end

    hound_session = Hound.start_session()

    on_exit(fn ->
      Hound.end_session(hound_session)
    end)
  end
end
