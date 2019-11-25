defmodule Mix.Tasks.MappConstruction.RevokeAdmin.Test do
  use MappConstruction.DataCase, async: true
  alias Mix.Tasks.MappConstruction.RevokeAdmin
  alias MappConstruction.Users
  import ExUnit.CaptureIO

  test "mapp_construction.revoke_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             RevokeAdmin.run([user.email])
           end) =~ "admin access revoked"

    refute Users.get_user(user.id).admin
  end
end
