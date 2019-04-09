defmodule AppTemplateWeb.AccountController do
  use AppTemplateWeb, :controller
  alias AppTemplateWeb.{User, Users}

  def edit(conn, _params) do
    current_user = conn.assigns[:current_user]
    changeset = User.update_changeset(current_user)

    render(conn, "edit.html", changeset: changeset, user: current_user)
  end

  def update(conn, %{"user" => user}) do
    current_user = conn.assigns[:current_user]

    case Users.update_user_account_details(current_user, user) do
      {:ok, user} ->
        changeset = User.update_changeset(user)

        conn
        |> put_flash(:info, "User Settings Saved.")
        |> render("edit.html", changeset: changeset)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
