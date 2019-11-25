defmodule MappConstructionWeb.LoadUserTest do
  use MappConstructionWeb.ConnCase, async: true
  alias Plug.Conn
  alias MappConstructionWeb.LoadUser
  alias MappConstruction.{AuthenticationToken}

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

  test "call with auth bearer token" do
    user = insert(:user)

    claims = user |> Map.from_struct() |> Map.take([:email])

    {:ok, token, _} = AuthenticationToken.generate_and_sign(claims, AuthenticationToken.signer())

    conn =
      build_conn()
      |> Conn.put_req_header("authorization", "Bearer #{token}")

    conn = LoadUser.call(conn, [])
    assert conn.assigns[:current_user] != nil
  end
end
