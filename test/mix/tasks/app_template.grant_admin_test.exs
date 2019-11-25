defmodule Mix.Tasks.MappConstruction.GrantAdmin.Test do
  use MappConstruction.DataCase, async: true
  alias Mix.Tasks.MappConstruction.GrantAdmin
  alias MappConstruction.Users
  import ExUnit.CaptureIO

  test "mapp_construction.make_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             GrantAdmin.run([user.email])
           end) =~ "is now an admin"

    assert Users.get_user(user.id).admin
  end
end
