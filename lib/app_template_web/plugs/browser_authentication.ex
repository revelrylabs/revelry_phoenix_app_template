defmodule AppTemplateWeb.BrowserAuthentication do
  @moduledoc """
  Loads user into connection if
  user has session
  """
  use Pow.Plug.Base
  import Plug.Conn
  alias AppTemplate.Users

  @impl true
  def fetch(conn, _config) do
    user = browser_auth(conn)

    {conn, user}
  end

  @impl true
  def create(conn, user, _config) do
    conn =
      conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)

    {conn, user}
  end

  @impl true
  def delete(conn, _config) do
    configure_session(conn, drop: true)
  end

  defp browser_auth(conn) do
    user_id = conn.assigns[:user_id] || get_session(conn, :user_id) || nil

    cond do
      user = conn.assigns[:current_user] ->
        user

      user = user_id && Users.get_user(user_id) ->
        user

      true ->
        nil
    end
  end
end
