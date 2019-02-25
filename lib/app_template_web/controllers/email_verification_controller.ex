defmodule AppTemplateWeb.EmailVerificationController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{EmailToken, Users}

  def verify(conn, %{"token" => token}) do
    with(
      {:ok, %{"email" => email}} <- EmailToken.verify_and_validate(token, EmailToken.signer()),
      user when not is_nil(user) <- Users.get_user_by_email(email),
      {:ok, _user} <- Users.update_email_verified(user)
    ) do
      conn
      |> put_flash(:info, "Email verified!")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid email token.")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def verify(conn, _) do
    conn
    |> put_flash(:error, "No email token found.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
