defmodule MappConstructionWeb.RequireAnonymousTest do
  use MappConstructionWeb.ConnCase, async: true
  alias MappConstructionWeb.{RequireAnonymous, LoadUser}
  alias Plug.Conn

  test "init" do
    assert RequireAnonymous.init([]) == []
  end

  test "call without user" do
    conn = build_conn()
    conn = get(conn, Routes.session_path(conn, :new))

    assert conn
           |> LoadUser.call([])
           |> RequireAnonymous.call([]) == conn
  end

  test "call with user" do
    conn =
      build_conn()
      |> Conn.assign(:user_id, insert(:user).id)
      |> LoadUser.call([])

    assert conn
           |> RequireAnonymous.call([])
           |> redirected_to() =~ Routes.page_path(conn, :index)
  end
end
