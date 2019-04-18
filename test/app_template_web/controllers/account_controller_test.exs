defmodule AppTemplateWeb.AccountControllerTest do
  use AppTemplateWeb.ConnCase, async: true
  use Bamboo.Test

  describe "Account Details" do
    setup do
      user = insert(:user)

      conn =
        build_conn()
        |> assign(:current_user, user)

      {:ok, [conn: conn, user: user]}
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
end
