defmodule AppTemplateWeb.AppDomainRedirectTest do
  @moduledoc """
  Tests for AppTemplateWeb.AppDomainRedirect
  """
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplateWeb.AppDomainRedirect

  test "init with active override" do
    assert AppDomainRedirect.init(active: true) == %{active: true}
  end

  test "init in test env defaults to false" do
    assert AppDomainRedirect.init([]) == %{active: false}
  end

  test "doesn't do anything when not active" do
    conn = %{build_conn() | host: "localhurst"}
    assert AppDomainRedirect.call(conn, %{active: false}) == conn
  end

  test "redirects from bad hostname when active" do
    port = get_in(Application.get_env(:app_template, AppTemplateWeb.Endpoint), [:http, :port])
    conn = %{build_conn() | host: "localhurst", request_path: "/page"}
    redir = AppDomainRedirect.call(conn, %{active: true})
    assert redirected_to(redir) == "http://localhost:#{port}/page"
  end

  test "preserves the query string and path" do
    port = get_in(Application.get_env(:app_template, AppTemplateWeb.Endpoint), [:http, :port])

    conn = %{
      build_conn()
      | host: "nondomain",
        request_path: "/page",
        query_string: "name=val&other=123"
    }

    redir = AppDomainRedirect.call(conn, %{active: true})
    assert redirected_to(redir) == "http://localhost:#{port}/page?name=val&other=123"
  end
end
