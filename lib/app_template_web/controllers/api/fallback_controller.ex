defmodule AppTemplateWeb.API.FallbackController do
  use AppTemplateWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(AppTemplateWeb.API.ErrorView, "422.json", changeset: changeset)
  end

  def call(conn, {:error, errors}) do
    conn
    |> Plug.Conn.put_status(:unprocessable_entity)
    |> render(AppTemplateWeb.API.ErrorView, "422.json", errors: errors)
  end

  def call(conn, :not_found) do
    errors = %{
      http: ["404: Not Found"]
    }

    conn
    |> Plug.Conn.put_status(404)
    |> render(AppTemplateWeb.API.ErrorView, "422.json", errors: errors)
  end
end
