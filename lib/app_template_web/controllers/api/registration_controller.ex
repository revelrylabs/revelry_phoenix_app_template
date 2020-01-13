defmodule AppTemplateWeb.API.RegistrationController do
  use AppTemplateWeb, :controller
  alias AppTemplateWeb.ErrorHelpers
  alias Plug.Conn

  action_fallback(AppTemplateWeb.API.FallbackController)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        render(conn, "new.json",
          token: "#{conn.private[:api_key].prefix}.#{conn.private[:api_key].key}"
        )

      {:error, %Ecto.Changeset{} = changeset, _conn} ->
        errors = Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        {:error, errors}
    end
  end
end
