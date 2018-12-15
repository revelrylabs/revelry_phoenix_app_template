defmodule AppTemplateWeb.RequireAuthTest do
  use AppTemplateWeb.ConnCase, async: true
  alias AppTemplateWeb.RequireAuth

  test "init" do
    assert RequireAuth.init([]) == []
  end
end
