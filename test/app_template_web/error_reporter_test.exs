defmodule AppTemplateWeb.ErrorReporter.Test do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplateWeb.ErrorReporter

  test "handle_errors when one of ignored routes" do
    assert ErrorReporter.handle_errors(%{request_path: "/favicon.ico"}, []) == nil
  end

  test "handle_errors when there is an error and user logged in" do
    user = insert(:user)

    conn =
      build_conn()
      |> Plug.Conn.assign(:current_user, user)

    assert ErrorReporter.handle_errors(conn, %{
             kind: :error,
             reason: "error",
             stack: []
           }) == :ok
  end

  test "handle_errors when there is an error and user not logged in" do
    conn = build_conn()

    assert ErrorReporter.handle_errors(conn, %{
             kind: :error,
             reason: "error",
             stack: []
           }) == :ok
  end
end
