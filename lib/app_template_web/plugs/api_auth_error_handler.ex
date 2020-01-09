defmodule AppTemplateWeb.APIAuthErrorHandler do
  use AppTemplateWeb, :controller
  alias Plug.Conn

  @spec call(Conn.t(), :not_authenticated) :: Conn.t()
  def call(conn, :not_authenticated) do
    errors = %{
      http: ["401: Not Authenticated"]
    }

    conn
    |> Plug.Conn.put_status(401)
    |> put_view(AppTemplateWeb.API.ErrorView)
    |> render("401.json", errors: errors)
  end
end
