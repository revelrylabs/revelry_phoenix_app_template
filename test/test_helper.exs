ExUnit.configure(exclude: [integration: true])

{:ok, _} = Application.ensure_all_started(:wallaby)

Application.put_env(:wallaby, :base_url, AppTemplateWeb.Endpoint.url())

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AppTemplate.Repo, :manual)
