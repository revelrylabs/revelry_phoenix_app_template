defmodule AppTemplateWeb.SessionController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{Authentication, Session, Sessions}

  def new(conn, _params) do
    url = add_next_url(conn, Routes.session_path(conn, :create))

    render(conn, "new.html", changeset: Sessions.new(), url: url)
  end

  def create(conn, %{"session" => session_params}) do
    {:ok, session} = Sessions.validate(%Session{}, session_params)

    case Authentication.login(conn, session.email, session.password) do
      {:ok, conn, _user} ->
        conn
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: get_redirect_url(conn, conn.query_params))

      {:error, _reason, conn} ->
        changeset = Sessions.new(session)
        url = add_next_url(conn, Routes.session_path(conn, :create))

        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Invalid email or password.")
        |> render("new.html", changeset: changeset, url: url)
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.logout()
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp add_next_url(conn, current_url) do
    if Map.has_key?(conn.query_params, "next") do
      current_url <> "?next=" <> URI.encode_www_form(Map.get(conn.query_params, "next"))
    else
      current_url
    end
  end

  defp get_redirect_url(conn, params) do
    if Map.has_key?(params, "next") do
      params
      |> Map.get("next")
      |> URI.decode_www_form()
      |> String.trim_trailing("?")
    else
      Routes.page_path(conn, :index)
    end
  end
end
