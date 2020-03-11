defmodule AppTemplateWeb.API.MeControllerTest do
  use AppTemplateWeb.ConnCase, async: true
  alias ExOauth2Provider.{Plug, AccessTokens}

  setup %{conn: conn} do
    user = insert(:user, password_hash: Bcrypt.hash_pwd_salt("abc123"))

    {:ok, application} =
      ExOauth2Provider.Applications.create_application(
        user,
        %{
          name: "AppTemplateClient",
          scopes: "public read write",
          redirect_uri: "https://example.com"
        },
        otp_app: :app_template
      )

    # Authenitcate client (ie. Mobile App) via client credentials
    {:ok, client_credentials} =
      ExOauth2Provider.Token.grant(
        %{
          "client_id" => application.uid,
          "client_secret" => application.secret,
          "grant_type" => "client_credentials",
          "scope" => "public"
        },
        otp_app: :app_template
      )

    client_credentials =
      AccessTokens.get_by_token(client_credentials.access_token, otp_app: :app_template)

    conn = Plug.set_current_access_token(conn, {:ok, client_credentials})

    [conn: conn, user: user, application: application]
  end

  test "me", %{conn: conn, user: user, application: application} do
    conn =
      post(
        conn,
        Routes.oauth_token_path(conn, :create, %{
          "client_id" => application.uid,
          "client_secret" => application.secret,
          "grant_type" => "password",
          "username" => user.email,
          "password" => "abc123",
          "scope" => "read write"
        })
      )

    body = json_response(conn, 200)

    # NOTE: the plug stack doesnt seem to be the same in test env
    user_credentials = AccessTokens.get_by_token(body["access_token"], otp_app: :app_template)

    conn =
      conn
      |> recycle()
      |> Plug.set_current_access_token({:ok, user_credentials})
      |> get(Routes.api_me_path(conn, :show))

    assert json_response(conn, 200) == %{"data" => %{"email" => user.email, "id" => user.id}}
  end

  test "unauthorized me", %{conn: conn} do
    conn = get(conn, Routes.api_me_path(conn, :show))
    assert text_response(conn, 403) == "Unauthorized"
  end
end
