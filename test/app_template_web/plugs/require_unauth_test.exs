defmodule AppTemplateWeb.RequireUnAuthTest do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplateWeb.{RequireUnauth, LoadUser}
  alias Plug.Conn

  test "init" do
    assert RequireUnauth.init([]) == []
  end

  test "call without user" do
    conn = build_conn()
    conn = get(conn, Routes.session_path(conn, :new))

    assert conn
           |> LoadUser.call([])
           |> RequireUnauth.call([]) == conn
  end

  test "call with user" do
    conn =
      build_conn()
      |> Conn.assign(:user_id, insert(:user).id)
      |> LoadUser.call([])

    assert conn
           |> RequireUnauth.call([])
           |> redirected_to() =~ Routes.page_path(conn, :index)
  end
end
