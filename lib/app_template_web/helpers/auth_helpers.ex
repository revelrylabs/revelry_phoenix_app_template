defmodule AppTemplateWeb.Helpers.AuthHelpers do
  @moduledoc """
  Conveniences for getting user authentication related session data returned from a successful Auth0 sign in request
  """
  import Phoenix.Controller

  def find_or_create(auth) do
    {:ok,
      %{
        id: auth.uid,
        name: name_from_auth(auth),
        avatar: avatar_from_auth(auth),
        email: email_from_auth(auth)
      }}
  end

  # handling avatar url from github, facebook, etc
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image
  defp avatar_from_auth(%{info: %{image: image}}), do: image
  defp avatar_from_auth(_auth), do: nil

  defp email_from_auth(%{info: %{email: email}}), do: email
  defp email_from_auth(_), do: nil

  defp name_from_auth(%{info: %{name: name}}), do: name

  defp name_from_auth(%{info: %{first_name: first_name, last_name: last_name}})
       when not is_nil(first_name) and not is_nil(last_name) do
    first_name <> " " <> last_name
  end

  defp name_from_auth(%{info: %{nickname: nickname}}), do: nickname

  defp name_from_auth(_), do: nil

  @doc """
  Get current signed in user session data
  """
  def signed_in?(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def has_flash?(conn) do
    get_flash(conn) != %{}
  end

  def get_flash_type(conn) do
    flash = get_flash(conn)

    if Map.has_key?(flash, "error") do
      :error
    else
      :info
    end
  end

  @doc """
  Generates auth0 logout url to sign out of auth0 layer.
  """
  def logout_url(conn) do
    config = Application.get_env(:ueberauth, Ueberauth.Strategy.Auth0.OAuth)
    return_to = AppTemplateWeb.Router.Helpers.url(conn)
    "https://#{config[:domain]}/v2/logout?client_id=#{config[:client_id]}&returnTo=#{return_to}/auth/sign_out"
  end

  @doc """
  Generates auth0 logout url to sign into the auth0 layer.
  """
  def login_url(conn) do
    Ueberauth.Strategy.Auth0.OAuth.authorize_url!(
      redirect_uri: AppTemplateWeb.Router.Helpers.url(conn) <> "/auth/auth0/callback",
      scope: "openid email"
    )
  end
end