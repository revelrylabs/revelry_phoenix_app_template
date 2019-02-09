defmodule AppTemplateWeb.UserController.Test do
  use AppTemplateWeb.ConnCase, async: true
  use Bamboo.Test

  setup %{conn: conn} do
    [conn: conn]
  end

  test "GET /register", %{conn: conn} do
    conn = get(conn, Routes.user_path(conn, :new))
    assert html_response(conn, 200) =~ "Register"
  end

  test "POST /register with invalid credentials", %{conn: conn} do
    conn =
      post(
        conn,
        Routes.user_path(conn, :create),
        user: %{
          email: "blah",
          new_password: "blahblah"
        }
      )

    assert html_response(conn, 422) =~ "Please fix the errors below."
  end

  describe "POST /register with valid credentials" do
    test "registers the user and redirects to the home page", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.user_path(conn, :create),
          user: %{
            email: "blah@blah.co",
            new_password: "blahblah",
            new_password_confirmation: "blahblah"
          }
        )

      assert_email_delivered_with(subject: "Welcome to AppTemplate!")
      assert redirected_to(conn) =~ Routes.page_path(conn, :index)
    end
  end
end
