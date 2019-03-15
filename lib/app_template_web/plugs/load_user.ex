defmodule AppTemplateWeb.LoadUser do
  @moduledoc """
  Loads user into connection if
  user has session
  """

  import Plug.Conn
  alias AppTemplate.{Users, AuthenticationToken}

  def init(opts) do
    opts
  end

  def call(conn, _) do
    handle_auth(conn)
  end

  defp handle_auth(conn) do
    case get_user_from_authorization_header(conn) do
      nil ->
        browser_auth(conn)

      user ->
        build_conn(conn, user)
    end
  end

  defp browser_auth(conn) do
    user_id = conn.assigns[:user_id] || get_session(conn, :user_id) || nil

    cond do
      user = conn.assigns[:current_user] ->
        build_conn(conn, user)

      user = user_id && Users.get_user(user_id) ->
        build_conn(conn, user)

      true ->
        build_conn(conn, nil)
    end
  end

  defp get_user_from_authorization_header(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{"email" => email}} <-
           AuthenticationToken.verify_and_validate(token, AuthenticationToken.signer()),
         current_user when not is_nil(current_user) <- Users.get_user_by_email(email) do
      current_user
    else
      _ ->
        nil
    end
  end

  defp build_conn(conn, nil) do
    conn
    |> assign(:current_user, nil)
  end

  defp build_conn(conn, user) do
    conn
    |> assign(:current_user, user)
  end
end
