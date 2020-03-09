defmodule Mix.Tasks.AppTemplate.RevokeAdmin.Test do
  use AppTemplate.DataCase, async: true
  alias Mix.Tasks.AppTemplate.RevokeAdmin
  alias AppTemplate.Users
  import ExUnit.CaptureIO

  test "app_template.revoke_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             RevokeAdmin.run([user.email])
           end) =~ "admin access revoked"

    assert Users.get_user(user.id).role == "user"
  end
end
