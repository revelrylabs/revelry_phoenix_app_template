defmodule AppTemplateWeb.API.RegistrationControllerTest do
  use AppTemplateWeb.ConnCase, async: true

  setup %{conn: conn} do
    user = insert(:user)

    api_key =
      insert(:api_key, user: user)
      |> IO.inspect()

    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer #{api_key.prefix}.test")

    [conn: conn, user: user, api_key: api_key]
  end

  test "register", %{conn: conn, user: user} do
    conn = get(conn, Routes.api_me_path(conn, :show))
    assert json_response(conn, 200) == %{"data" => %{"email" => user.email, "id" => user.id}}
  end

  test "resgister wth error", %{conn: conn} do
    conn = get(build_conn(), Routes.api_me_path(conn, :show))
    assert json_response(conn, 401) == %{"errors" => %{"http" => ["401: Unauthorized"]}}
  end
end
