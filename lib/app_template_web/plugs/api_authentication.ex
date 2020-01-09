defmodule AppTemplateWeb.APIAuthentication do
  @moduledoc """
  Loads user from API token
  """
  use Pow.Plug.Base
  import Bcrypt, only: [check_pass: 3, no_user_verify: 1]

  alias Plug.Conn
  alias AppTemplate.{Users, APIKey}

  @impl true
  @spec fetch(Conn.t(), Config.t()) :: {Conn.t(), map() | nil}
  def fetch(conn, _config) do
    case fetch_auth_token(conn) do
      {:ok, %APIKey{} = api_key} ->
        {conn, api_key.user}

      _ ->
        {conn, nil}
    end
  end

  @impl true
  @spec create(Conn.t(), map(), Config.t()) :: {Conn.t(), map()}
  def create(conn, user, _config) do
    {:ok, api_key} = Users.create_api_key_for_user(%{user_id: user.id, name: "high"})

    conn =
      conn
      |> Conn.put_private(:api_key, api_key)

    {conn, user}
  end

  @impl true
  @spec delete(Conn.t(), Config.t()) :: Conn.t()
  def delete(conn, _config) do
    {:ok, %APIKey{} = api_key} = fetch_auth_token(conn)
    Users.delete_api_key_for_user(api_key.id)

    conn
  end

  defp fetch_auth_token(conn) do
    with ["Bearer " <> token] <- Plug.Conn.get_req_header(conn, "authorization") |> IO.inspect(),
         [app, prefix, key] <- String.split(token, "."),
         api_key when not is_nil(api_key) <-
           Users.get_api_key_for_user("#{app}.#{prefix}"),
         {:ok, _} = check_pass(api_key, key, hash_key: :key_hash) do
      {:ok, api_key}
    else
      _error ->
        no_user_verify([])

        {:error, nil}
    end
  end
end
