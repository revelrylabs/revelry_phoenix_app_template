defmodule AppTemplateWeb.S3Controller.Test do
  use AppTemplateWeb.ConnCase, async: true

  test "GET /images/sign when signed out", %{conn: conn} do
    conn = get(conn, Routes.s3_path(conn, :sign))
    body = response(conn, 403)
    assert body =~ "Unauthorized"
  end

  describe "GET /images/sign when signed in" do
    setup %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> assign(:current_user, user)

      [user: user, conn: conn]
    end

    test "with no file_name param", %{conn: conn} do
      conn = get(conn, Routes.s3_path(conn, :sign))
      body = json_response(conn, 400)
      assert "Invalid request" in body["errors"]["all"]
    end

    test "with file_name param", %{conn: conn} do
      conn = get(conn, Routes.s3_path(conn, :sign), file_name: "blah.jpg")
      body = json_response(conn, 200)
      assert body["data"]["file_name"]
      assert body["data"]["file_type"]
      assert body["data"]["signed_request"]
      assert body["data"]["url"]
    end

    test "with bad file", %{conn: conn} do
      conn = get(conn, Routes.s3_path(conn, :sign), file_name: "badfile.bad")
      body = json_response(conn, 400)
      assert body["errors"]["all"]
    end
  end
end
