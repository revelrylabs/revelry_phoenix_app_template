defmodule AppTemplateWeb.LoadUser do
  @moduledoc """
  Loads user into connection if
  user has session
  """

  import Plug.Conn
  alias AppTemplate.Users

  def init(opts) do
    opts
  end

  def call(conn, _) do
    handle_auth(conn)
  end

  defp handle_auth(conn) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        build_conn(conn, user)
      user = user_id && Users.get_user(user_id) ->
        build_conn(conn, user)
      true ->
        build_conn(conn, nil)
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
