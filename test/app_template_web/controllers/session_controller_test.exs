defmodule AppTemplateWeb.SessionController.Test do
  use AppTemplateWeb.ConnCase, async: true
  alias Bcrypt

  test "GET /session/new", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "Log In"
  end

  test "GET /session/new with a next url", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new, next: Routes.session_path(conn, :delete)))
    assert html_response(conn, 200) =~ "Log In"
  end

  test "POST /session/new with invalid credentials", %{conn: conn} do
    conn = post(conn, Routes.session_path(conn, :new), session: [email: "blah", password: "blah"])
    assert html_response(conn, 422) =~ "Invalid email or password"
  end

  describe "POST /session/new with valid credentials" do
    test "logs the normal user in and redirects to the main menu", %{conn: conn} do
      user = insert(:user, password: Bcrypt.hash_pwd_salt("blah"))

      conn =
        post(conn, Routes.session_path(conn, :new), session: [email: user.email, password: "blah"])

      assert redirected_to(conn) =~ Routes.page_path(conn, :index)
    end

    test "logs the normal user in and redirects to next page", %{conn: conn} do
      user = insert(:user, password: Bcrypt.hash_pwd_salt("blah"))

      conn =
        post(conn, Routes.session_path(conn, :new, next: Routes.session_path(conn, :delete)),
          session: [email: user.email, password: "blah"]
        )

      assert redirected_to(conn) =~ Routes.session_path(conn, :delete)
    end
  end

  test "GET /session/delete when logged out", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :delete))
    assert redirected_to(conn) =~ Routes.session_path(conn, :new)
  end

  test "GET /session/delete when logged in", %{conn: conn} do
    user = insert(:user)

    conn =
      conn
      |> assign(:current_user, user)

    conn = get(conn, Routes.session_path(conn, :delete))
    assert redirected_to(conn) =~ Routes.page_path(conn, :index)
  end
end
