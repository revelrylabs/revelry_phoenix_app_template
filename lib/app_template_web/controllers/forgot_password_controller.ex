defmodule AppTemplateWeb.ForgotPasswordController do
  @moduledoc """
    handles user password resets
  """
  use AppTemplateWeb, :controller
  alias AppTemplate.{EmailToken, Users, User, EmailBuilder, Mailer}

  plug(:ensure_valid_token when action in [:edit, :reset])

  @doc """
    render request new password form
  """
  def new(conn, _params) do
    changeset = User.forgot_password_changeset(%User{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
    check that email is active and send pw reset email
  """
  def create(conn, %{"user" => %{"email" => email}}) do
    case Users.get_user_by_email(email) do
      nil ->
        changeset = User.forgot_password_changeset(%User{})

        conn
        |> put_flash(:error, gettext("User with email %{email} not found", email: email))
        |> render("new.html", changeset: changeset)

      user ->
        user
        |> EmailBuilder.build_email_password_reset()
        |> Mailer.deliver_later()

        changeset = User.forgot_password_changeset(%User{})

        conn
        |> put_flash(:info, gettext("Password reset email sent to %{email}", email: email))
        |> render("new.html", changeset: changeset)
    end
  end

  @doc """
  Render Password Reset Email
  """
  def edit(conn, %{"token" => token}) do
    %{
      "user_id" => user_id
    } = conn.assigns.token_claims

    user = Users.get_user(user_id)

    changeset = User.forgot_password_changeset(user)

    conn
    |> put_flash(:info, gettext("Password reset token verified."))
    |> render("edit.html", changeset: changeset, token: token, user: user)
  end

  @doc """
  Update User Password
  """
  def reset(conn, %{"token" => token} = params) do
    %{
      "user_id" => user_id
    } = conn.assigns.token_claims

    user = Users.get_user(user_id)

    case Users.update_password_for_user_forgot(user, params) do
      {:ok, user} ->
        user
        |> EmailBuilder.build_password_changed_email()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, gettext("Your password has been reset!"))
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Please fix the errors below"))
        |> render("edit.html", changeset: changeset, token: token)
    end
  end

  @doc """
  Plug to verify email token
  """
  def ensure_valid_token(conn, _) do
    with(
      token when not is_nil(token) <- Map.get(conn.params, "token"),
      {:ok, claims} <- EmailToken.verify_and_validate(token, EmailToken.signer())
    ) do
      assign(conn, :token_claims, claims)
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid email token.")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
    end
  end
end
