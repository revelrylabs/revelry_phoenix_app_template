defmodule AppTemplateWeb.LoadUserFromToken do
  @moduledoc """
  Loads user from API token
  """
  import Plug.Conn
  alias AppTemplate.Users

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case ExOauth2Provider.Plug.current_access_token(conn) do
      %AppTemplate.OauthAccessTokens.OauthAccessToken{resource_owner_id: resource_owner_id} ->
        user = Users.get_user(resource_owner_id)

        conn
        |> assign(:current_user, user)

      _ ->
        conn
    end
  end
end
