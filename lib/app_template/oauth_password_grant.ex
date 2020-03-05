defmodule AppTemplate.OAuthPasswordGrant do
  alias AppTemplate.{User, Repo}

  def authenticate(username, password) do
    IO.inspect(username)
    IO.inspect(password)

    User
    |> Repo.get_by(email: String.downcase(username))
    |> verify_password(password)
  end

  defp verify_password(nil, password) do
    # Prevent timing attack
    Bcrypt.verify_pass(password, "")

    {:error, :no_user_found}
  end

  defp verify_password(%{password_hash: password_hash} = user, password) do
    case Bcrypt.verify_pass(password, password_hash) do
      true -> {:ok, user}
      false -> {:error, :invalid_password}
    end
  end
end
