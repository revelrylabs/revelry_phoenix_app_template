defmodule MappConstructionWeb.RequireAuthenticationTest do
  use MappConstructionWeb.ConnCase, async: true
  alias MappConstructionWeb.RequireAuthentication

  test "init" do
    assert RequireAuthentication.init([]) == []
  end
end
