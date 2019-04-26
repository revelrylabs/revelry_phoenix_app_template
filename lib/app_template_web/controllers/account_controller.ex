defmodule AppTemplateWeb.AccountController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{Authentication, EmailBuilder, Mailer, User, Users}

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user}) do
    case Users.create_user(user) do
      {:ok, user} ->
        user
        |> EmailBuilder.welcome_email()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, gettext("Registration successful!"))
        |> Authentication.new_session(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, gettext("Please fix the errors below."))
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    current_user = conn.assigns[:current_user]
    password_changeset = User.update_password_changeset(conn.assigns.current_user)
    account_changeset = User.update_changeset(current_user)

    render(conn, "edit.html",
      password_changeset: password_changeset,
      account_changeset: account_changeset,
      user: current_user
    )
  end

  def update(conn, %{"user" => user}) do
    current_user = conn.assigns[:current_user]

    case Users.update_user_account_details(current_user, user) do
      {:ok, user} ->
        account_changeset = User.update_changeset(user)
        password_changeset = User.update_password_changeset(conn.assigns.current_user)

        conn
        |> put_flash(:info, "User Settings Saved.")
        |> render("edit.html",
          account_changeset: account_changeset,
          password_changeset: password_changeset
        )

      {:error, %Ecto.Changeset{} = account_changeset} ->
        password_changeset = User.update_password_changeset(conn.assigns.current_user)

        render(conn, "edit.html",
          account_changeset: account_changeset,
          password_changeset: password_changeset
        )
    end
  end

  def new_password(conn, _params) do
    changeset = User.update_password_changeset(conn.assigns.current_user)

    render(conn, "edit.html", changeset: changeset)
  end

  def update_password(conn, %{"user" => user_params}) do
    current_user = conn.assigns[:current_user]

    case Users.update_password_for_user(current_user, user_params) do
      {:ok, user} ->
        user
        |> EmailBuilder.build_password_changed_email()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, gettext("Password updated successfully"))
        |> redirect(to: Routes.account_path(conn, :edit))

      {:error, %Ecto.Changeset{} = password_changeset} ->
        account_changeset = User.update_changeset(current_user)

        conn
        |> put_status(:unprocessable_entity)
        |> render("edit.html",
          password_changeset: password_changeset,
          account_changeset: account_changeset
        )
    end
  end
end
