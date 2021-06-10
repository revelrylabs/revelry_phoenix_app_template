defmodule AppTemplateWeb.IntegrationCase do
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
      @moduletag :feature
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppTemplate.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AppTemplate.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(AppTemplate.Repo, self())

    # starts hound session in a headless chrome instance
    hound_session =
      Hound.start_session(
        additional_capabilities: %{
          javascriptEnabled: true,
          chromeOptions: %{
            "args" => [
              "--user-agent=#{
                Hound.Browser.user_agent(:chrome) |> Hound.Metadata.append(metadata)
              }",
              "--headless",
              "--disable-gpu",
              "--window-size=1024x768"
            ]
          }
        }
      )

    on_exit(fn ->
      Hound.end_session(hound_session)
    end)
  end
end
