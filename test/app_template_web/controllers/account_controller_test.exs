defmodule MappConstructionWeb.AccountControllerTest do
  use MappConstructionWeb.ConnCase, async: true
  use Bamboo.Test

  describe "Account Details" do
    setup do
      user = insert(:user)

      conn =
        build_conn()
        |> assign(:current_user, user)

      {:ok, [conn: conn, user: user]}
    end

    test "GET /account/settings", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :edit))
      assert html_response(conn, 200) =~ "User Account Details"
    end

    test "PUT /account/settings", %{conn: conn} do
      conn =
        put(conn, Routes.account_path(conn, :update), %{
          "user" => %{
            "email" => "test@test.com"
          }
        })

      assert html_response(conn, 200) =~ "test@test.com"
    end

    test "PUT /account/password with valid credentials", %{conn: conn} do
      conn =
        put(
          conn,
          Routes.account_path(conn, :update_password),
          user: %{
            current_password: "password",
            new_password: "AppleApple1!",
            new_password_confirmation: "AppleApple1!"
          }
        )

      assert_email_delivered_with(to: [nil: conn.assigns.current_user.email])
      assert redirected_to(conn) =~ Routes.account_path(conn, :edit)
    end

    test "PUT /account/password with invalid current password", %{conn: conn} do
      conn =
        put(
          conn,
          Routes.account_path(conn, :update_password),
          user: %{
            current_password: "dingus",
            new_password: "AppleApple1!",
            new_password_confirmation: "AppleApple1!"
          }
        )

      assert html_response(conn, 422) =~ "invalid"
    end
  end

  describe "Account Registration" do
    setup %{conn: conn} do
      [conn: conn]
    end

    test "GET /register", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :new))
      assert html_response(conn, 200) =~ "Register"
    end

    test "POST /register with invalid credentials", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.account_path(conn, :create),
          user: %{
            email: "blah",
            new_password: "blahblah"
          }
        )

      assert html_response(conn, 422) =~ "Please fix the errors below."
    end

    test "POST /register with used email", %{conn: conn} do
      user = insert(:user)

      conn =
        post(
          conn,
          Routes.account_path(conn, :create),
          user: %{
            email: user.email,
            new_password: "blahblah",
            new_password_confirmation: "blahblah"
          }
        )

      assert html_response(conn, 422) =~ "already in use"
    end

    test "POST /register with valid credentials", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.account_path(conn, :create),
          user: %{
            email: "blah@blah.co",
            new_password: "blahblah",
            new_password_confirmation: "blahblah"
          }
        )

      assert_email_delivered_with(subject: "Welcome to MappConstruction!")
      assert redirected_to(conn) =~ Routes.page_path(conn, :index)
    end
  end
end
