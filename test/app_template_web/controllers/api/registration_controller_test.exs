defmodule AppTemplateWeb.API.RegistrationControllerTest do
  use AppTemplateWeb.ConnCase, async: true

  describe "create/2" do
    @valid_params %{
      "user" => %{
        "email" => "test@example.com",
        "password" => "secret1234",
        "confirm_password" => "secret1234"
      }
    }
    @invalid_params %{
      "user" => %{"email" => "invalid", "password" => "secret1234", "confirm_password" => ""}
    }

    test "with valid params", %{conn: conn} do
      conn = post(conn, Routes.api_registration_path(conn, :create, @valid_params))

      assert json = json_response(conn, 200)
      assert json["data"]["token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, Routes.api_registration_path(conn, :create, @invalid_params))

      assert json = json_response(conn, 422)

      assert json["errors"]["confirm_password"] == ["not same as password"]
      assert json["errors"]["email"] == ["has invalid format"]
    end
  end
end
