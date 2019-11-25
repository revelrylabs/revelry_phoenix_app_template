defmodule MappConstructionWeb.EmailVerificationController.Test do
  use MappConstructionWeb.ConnCase, async: true
  alias MappConstruction.EmailToken

  test "verify without token", %{conn: conn} do
    conn = get(conn, Routes.email_verification_path(conn, :verify))
    assert redirected_to(conn) =~ Routes.page_path(conn, :index)
  end

  test "verify with invalid token", %{conn: conn} do
    user = insert(:user)

    {:ok, week_ago, _} = DateTime.from_iso8601("2015-01-23T23:50:07Z")
    week_ago = DateTime.to_unix(week_ago)

    token =
      EmailToken.generate_and_sign!(
        %{"exp" => week_ago, "email" => user.email},
        EmailToken.signer()
      )

    conn = get(conn, Routes.email_verification_path(conn, :verify, token: token))
    assert redirected_to(conn) =~ Routes.page_path(conn, :index)
  end

  test "verify with valid token", %{conn: conn} do
    user = insert(:user)

    token = EmailToken.generate_and_sign!(%{"email" => user.email}, EmailToken.signer())

    conn = get(conn, Routes.email_verification_path(conn, :verify, token: token))
    assert redirected_to(conn) =~ Routes.page_path(conn, :index)
  end
end
