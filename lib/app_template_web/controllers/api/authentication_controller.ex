defmodule MappConstructionWeb.API.AuthenticationController do
  use MappConstructionWeb, :controller
  alias MappConstruction.{Authentication, Session, Sessions}

  action_fallback(MappConstructionWeb.API.FallbackController)

  def authenticate(conn, %{"data" => session_params}) do
    {:ok, session} = Sessions.validate(%Session{}, session_params)

    case Authentication.authenticate(conn, session.email, session.password) do
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
