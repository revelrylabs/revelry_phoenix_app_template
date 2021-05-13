defmodule AppTemplateWeb.AuthHelpersTest do
  @moduledoc """
  tests whether or not signed_in? function accurately dettermines if user is signed in or not
  """
  use AppTemplateWeb.ConnCase, async: true

  alias Plug.Test
  alias AppTemplateWeb.Helpers.AuthHelpers

  test "is user signed in pre-check", %{conn: conn} do
    conn = init_test_session(conn, current_user: nil)
    conn = get(conn, "/")
    assert AuthHelpers.signed_in?(conn) == nil
  end

  test "is user signed in after creating session", %{conn: conn} do
    user = %{id: "testuser1", email: "email@google.com"}
    conn = init_test_session(conn, current_user: user)
    conn = get(conn, "/")
    assert AuthHelpers.signed_in?(conn) != nil
  end

  @valid_auth0_res %{
    uid: "google-oauth2|xxx12345",
    info: %{
      id: "7seQ234",
      email: "test@revelry.co",
      name: "Kevin Duckworth",
      first_name: "Kevin",
      last_name: "Duckworth",
      urls: %{
        avatar_url: "https://aws.s3.com/kevin-duckworth-jumper.jpg"
      }
    }
  }

  describe "`AppTemplateWeb.AuthHelpers.find_or_create`" do
    test "returns id, email, name, avatar when valid response" do
      auth = AuthHelpers.find_or_create(@valid_auth0_res)

      assert(
        {:ok,
          %{
            id: "google-oauth2|xxx12345",
            email: "test@revelry.co",
            name: "Kevin Duckworth",
            avatar: "https://aws.s3.com/kevin-duckworth-jumper.jpg"
          }} == auth
      )
    end
  end
end