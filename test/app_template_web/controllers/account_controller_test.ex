defmodule AppTemplateWeb.PageControllerTest do
  use AppTemplateWeb.ConnCase, async: true

  describe "Account Details" do
    setup do
      user = insert(:user)

      conn =
        build_conn()
        |> assign(:current_user, user)

      {:ok, [conn: conn, user: user]}
    end

    test "GET /account/settings", %{conn: conn} do
      conn = get(conn, account_path(conn, :edit))
      assert html_response(conn, 200) =~ "User Account Details"
    end

    test "PUT /account/settings", %{conn: conn} do
      conn =
        put(conn, account_path(conn, :update), %{
          "user" => %{
            "email" => "test@test.com"
          }
        })

      assert html_response(conn, 200) =~ "test@test.com"
    end
  end
end
