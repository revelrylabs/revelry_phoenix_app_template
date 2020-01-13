defmodule AppTemplateWeb.API.AuthenticationControllerTest do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplate.{Repo, User}
  alias Pow.Ecto.Schema.Password

  describe "create/2" do
    setup %{conn: conn} do
      user =
        Repo.insert!(%User{
          email: "test1@example.com",
          password_hash: Password.pbkdf2_hash("password")
        })
        |> IO.inspect()

      {:ok, conn: conn}
    end

    @create_params %{
      "user" => %{
        "email" => "test2@example.com",
        "password" => "password",
        "confirm_password" => "password"
      }
    }

    @valid_params %{"user" => %{"email" => "test@example.com", "password" => "password"}}
    @invalid_params %{"user" => %{"email" => "test@example.com", "password" => "notpassword"}}

    @tag :cool
    test "with valid params", %{conn: conn} do
      conn =
        post(conn, Routes.api_registration_path(conn, :create, @create_params))
        |> IO.inspect()

      conn =
        post(
          conn,
          Routes.api_authentication_path(conn, :create, @valid_params)
        )

      assert json = json_response(conn, 200)
      assert json["data"]["token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, Routes.api_authentication_path(conn, :create, @invalid_params))

      assert json = json_response(conn, 422)

      assert json["errors"] == ["Invalid email or password"]
    end
  end
end
