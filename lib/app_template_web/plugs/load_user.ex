defmodule AppTemplateWeb.LoadUser do
  @moduledoc """
  Loads user into connection if
  user has session
  """
  use Pow.Plug.Base
  import Plug.Conn
  alias AppTemplate.{Users, AuthenticationToken}

  @impl true
  def fetch(conn, _config) do
    user = handle_auth(conn)

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

  defp handle_auth(conn) do
    case get_user_from_authorization_header(conn) do
      nil ->
        browser_auth(conn)

      user ->
        user
    end
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
end
