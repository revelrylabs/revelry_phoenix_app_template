defmodule AppTemplate.Authentication do
  @moduledoc """
  Handles logging users in and out
  """

  import Plug.Conn
  import Bcrypt, only: [check_pass: 3, no_user_verify: 1]
  alias AppTemplate.{AuthenticationToken, Users}

  @doc """
  Checks if valid credentials, but does not create a new session.
  This is useful for API authorization
  """
  def authorize(conn, email, given_pass) do
    case verify_credentials(email, given_pass) do
      {:ok, user} ->
        claims = user |> Map.from_struct() |> Map.take([:email])

        {:ok, token, _} =
          AuthenticationToken.generate_and_sign(claims, AuthenticationToken.signer())

        {:ok, %{access_token: token, expires_in: AuthenticationToken.expires_in(), user: user}}

      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def login(conn, email, given_pass) do
    case verify_credentials(email, given_pass) do
      {:ok, user} ->
        {:ok, new_session(conn, user), user}

      {:error, reason} ->
        {:error, reason, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def verify_credentials(email, given_pass) do
    user = Users.get_user_by_email(email)

    if user && check_pass(user, given_pass, []) do
      {:ok, user}
    else
      no_user_verify([])
      {:error, :unauthorized}
    end
  end

  def new_session(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
