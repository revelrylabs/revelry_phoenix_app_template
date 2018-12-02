defmodule AppTemplateWeb.SessionController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{Auth, Session, Sessions}

  def new(conn, _params) do
    render(conn, "new.html", changeset: Sessions.new())
  end

  def create(conn, %{"session" => session_params}) do
    {:ok, session} = Sessions.validate(%Session{}, session_params)

    case Auth.login(conn, session.email, session.password) do
      {:ok, conn, _user} ->
        conn
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        changeset = Sessions.new(session)

        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
