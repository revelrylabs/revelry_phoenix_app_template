defmodule AppTemplateWeb.PageControllerTest do
  use AppTemplateWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome"
  end

  test "GET /styleguide", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :styleguide))
    assert html_response(conn, 200) =~ "Style Guide"
  end
end
