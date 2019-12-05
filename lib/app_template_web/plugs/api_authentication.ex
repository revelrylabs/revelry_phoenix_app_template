defmodule AppTemplateWeb.APIAuthentication do
  @moduledoc """
  Loads user from API token
  """
  import Plug.Conn
  import Bcrypt, only: [check_pass: 3, no_user_verify: 1]
  alias AppTemplate.Users

  def init(opts) do
    opts
  end

  def call(conn, _) do
    get_user_from_authorization_header(conn)
  end

  defp get_user_from_authorization_header(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         [app, prefix, key] <- String.split(token, "."),
         api_key when not is_nil(api_key) <-
           Users.get_api_key_for_user("#{app}.#{prefix}"),
         {:ok, _} = check_pass(api_key, key, hash_key: :key_hash) do
      conn
      |> assign(:current_user, api_key.user)
    else
      _ ->
        no_user_verify([])

        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(AppTemplateWeb.API.ErrorView)
        |> Phoenix.Controller.render(:"401")
        |> halt()
    end
  end
end
