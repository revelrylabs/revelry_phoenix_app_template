defmodule AppTemplateWeb.RequireAuthenticationTest do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplateWeb.RequireAuthentication

  test "init" do
    assert RequireAuthentication.init([]) == []
  end
end
