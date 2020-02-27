defmodule Mix.Tasks.AppTemplate.GrantAdmin.Test do
  use AppTemplate.DataCase, async: true
  alias Mix.Tasks.AppTemplate.GrantAdmin
  alias AppTemplate.Users
  import ExUnit.CaptureIO

  test "app_template.make_admin" do
    user = insert(:user)

    assert capture_io(fn ->
             GrantAdmin.run([user.email])
           end) =~ "is now an admin"

    assert Users.get_user(user.id).role == "admin"
  end
end
