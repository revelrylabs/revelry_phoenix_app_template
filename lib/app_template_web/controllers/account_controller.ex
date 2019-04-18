defmodule AppTemplateWeb.AccountController do
  use AppTemplateWeb, :controller
  alias AppTemplate.{EmailBuilder, Mailer, User, Users}

  def edit(conn, _params) do
    current_user = conn.assigns[:current_user]
    changeset = User.update_password_changeset(conn.assigns.current_user)

    render(conn, "edit.html", changeset: changeset, user: current_user)
  end

  def new_password(conn, _params) do
    changeset = User.update_password_changeset(conn.assigns.current_user)

    render(conn, "edit.html", changeset: changeset)
  end

  def update_password(conn, %{"user" => user_params}) do
    case Users.update_password_for_user(conn.assigns.current_user, user_params) do
      {:ok, user} ->
        user
        |> EmailBuilder.build_password_changed_email()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, gettext("Password updated successfully"))
        |> redirect(to: Routes.account_path(conn, :edit))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("edit.html", changeset: changeset)
    end
  end
end
