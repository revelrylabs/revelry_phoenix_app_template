defmodule AppTemplateWeb.API.AuthenticationController.Test do
  use AppTemplateWeb.ConnCase, async: true
  alias Bcrypt

  test "POST /api/authenticate with invalid credentials", %{conn: conn} do
    conn =
      post(conn, Routes.api_authentication_path(conn, :authenticate),
        data: [email: "blah", password: "blah"]
      )

    assert %{"errors" => %{"authorize" => ["Invalid email or password."]}} =
             json_response(conn, 422)
  end

  describe "POST /api/authenticate with valid credentials" do
    test "logs the normal user in and redirects to the main menu", %{conn: conn} do
      user = insert(:user, password_hash: Bcrypt.hash_pwd_salt("blah"))

      conn =
        post(conn, Routes.api_authentication_path(conn, :authenticate),
          data: [email: user.email, password: "blah"]
        )

      assert %{
               "data" => %{
                 "attributes" => %{
                   "access_token" => _,
                   "expires_in" => _,
                   "token_type" => "Bearer"
                 },
                 "id" => _,
                 "type" => "token"
               }
             } = json_response(conn, 200)
    end
  end
end
