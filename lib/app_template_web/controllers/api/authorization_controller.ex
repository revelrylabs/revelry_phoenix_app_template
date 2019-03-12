defmodule AppTemplateWeb.API.AuthorizationController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{Authentication, Session, Sessions}

  def authorize(conn, %{"data" => session_params}) do
    {:ok, session} = Sessions.validate(%Session{}, session_params)

    case Authentication.authorize(conn, session.email, session.password) do
      {:ok, token} ->
        conn
        |> put_status(200)
        |> render("show.json", token: token)

      {:error, _reason, _conn} ->
        errors = %{
          authorize: ["Invalid email or password."]
        }

        {:error, errors}
    end
  end
end
