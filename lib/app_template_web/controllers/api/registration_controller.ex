defmodule AppTemplateWeb.API.RegistrationController do
  use AppTemplateWeb, :controller
  alias Plug.Conn

  action_fallback(AppTemplateWeb.API.FallbackController)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        IO.inspect(conn.private[:api_key])

        render(conn, "new.json",
          token: "#{conn.private[:api_key].prefix}.#{conn.private[:api_key].key}"
        )

      error ->
        error
    end
  end
end
