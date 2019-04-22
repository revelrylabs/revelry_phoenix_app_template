defmodule AppTemplateWeb.AdminControllerTest do
  use AppTemplateWeb.ConnCase, async: true
  use Bamboo.Test

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    {:ok, [conn: conn, user: user]}
  end

  test "get users index", %{conn: conn} do
    conn =
      get(
        conn,
        Routes.admin_path(conn, :index, "user")
      )

    assert html_response(conn, 200) =~ "User"
  end

  test "new user page", %{conn: conn} do
    conn =
      get(
        conn,
        Routes.admin_path(conn, :new, "user")
      )

    assert html_response(conn, 200) =~ "Create"
  end

  test "create new user", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.admin_path(conn, :new, "user"),
        data: %{
          new_password: "AppleApple1!",
          new_password_confirmation: "AppleApple1!",
          email_verified: true,
          email: "yes@example.com"
        }
      )

    assert redirected_to(conn) =~ "/admin/edit/"
  end

  test "edit user page", %{conn: conn, user: user} do
    conn =
      get(
        conn,
        Routes.admin_path(conn, :edit, "user", user.id)
      )

    assert html_response(conn, 200) =~ "Edit"
  end

  test "edit existing user", %{conn: conn, user: user} do
    conn =
      put(
        conn,
        Routes.admin_path(conn, :update, "user", user.id),
        data: %{
          email: "no@example.com"
        }
      )

    assert redirected_to(conn) =~ "/admin/edit/"
  end
end
