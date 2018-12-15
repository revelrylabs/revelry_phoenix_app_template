defmodule AppTemplateWeb.LoadUserTest do
  use AppTemplateWeb.ConnCase, async: true
  alias Plug.Conn
  alias AppTemplateWeb.LoadUser

  test "init" do
    assert LoadUser.init([]) == []
  end

  test "call" do
    user = insert(:user)

    conn =
      build_conn()
      |> Conn.assign(:user_id, user.id)

    conn = LoadUser.call(conn, [])
    assert conn.assigns[:current_user] != nil
  end
end
