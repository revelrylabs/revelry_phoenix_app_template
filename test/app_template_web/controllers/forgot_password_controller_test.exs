defmodule AppTemplateWeb.UserPasswordController.Test do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplate.{EmailToken}
  use Bamboo.Test

  setup %{conn: conn} do
    [conn: conn]
  end

  describe "password reset screen" do
    test "allows existing user to access reset password screen with email link", %{conn: conn} do
      user = insert(:user)

      claims = %{
        "user_id" => user.id,
        "aud" => "AppTemplate",
        "iss" => "AppTemplate"
      }

      token = EmailToken.generate_and_sign!(claims, EmailToken.signer())

      conn =
        get(
          conn,
          Routes.forgot_password_path(conn, :edit, user, token: token)
        )

      assert html_response(conn, 200) =~ "Reset Password"
    end

    test "sends email and redirects to sign-in when password changed", %{conn: conn} do
      user = insert(:user)

      claims = %{
        "user_id" => user.id,
        "aud" => "AppTemplate",
        "iss" => "AppTemplate"
      }

      token = EmailToken.generate_and_sign!(claims, EmailToken.signer())

      conn =
        post(
          conn,
          Routes.forgot_password_path(conn, :reset),
          %{
            current_password: user.password,
            new_password: "Blah@blah.co1",
            new_password_confirmation: "Blah@blah.co1",
            token: token
          }
        )

      assert redirected_to(conn) =~ Routes.session_path(conn, :new)
      assert_email_delivered_with(to: [nil: user.email])
    end
  end
end
