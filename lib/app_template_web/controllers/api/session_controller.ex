defmodule AppTemplateWeb.API.SessionController do
  use AppTemplateWeb, :controller
  alias Plug.Conn

  action_fallback(AppTemplateWeb.API.FallbackController)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    IO.puts("controller create")

    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        IO.puts("okok ")

        render(conn, "new.json",
          token: "#{conn.private[:api_key].prefix}.#{conn.private[:api_key].key}"
        )

      error ->
        IO.inspect(error)
        error
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    {:ok, conn} = Pow.Plug.clear_authenticated_user(conn)

    render(conn, "show.json")
  end
end
