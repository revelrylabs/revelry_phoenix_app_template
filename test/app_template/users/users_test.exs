defmodule AppTemplate.Users.Test do
  use AppTemplate.DataCase, async: true
  alias AppTemplate.Users

  test "create" do
    {:ok, user} =
      Users.create_user(%{
        "email" => "joe@example.com",
        "password" => "hihihihihi",
        "password_confirmation" => "hihihihihi"
      })

    assert user.email == "joe@example.com"
  end

  test "get_user_by_email" do
    user = insert(:user)
    user_from_db = Users.get_user_by_email(user.email)

    assert user.email == user_from_db.email
  end

  test "get_user" do
    user = insert(:user)
    user_from_db = Users.get_user(user.id)

    assert user.email == user_from_db.email
  end

  test "create_api_key_for_user" do
    user = insert(:user)
    {:ok, result} = Users.create_api_key_for_user(%{user_id: user.id, name: "high"})

    assert result.user_id == user.id
  end

  test "update_api_key_for_user" do
    user = insert(:user)
    {:ok, api_key} = Users.create_api_key_for_user(%{user_id: user.id, name: "high"})
    {:ok, updated_api_key} = Users.update_api_key_for_user(api_key, %{name: "low"})

    assert updated_api_key.name == "low"
  end

  test "get_api_key_for_user" do
    user = insert(:user)
    {:ok, api_key} = Users.create_api_key_for_user(%{user_id: user.id, name: "high"})
    api_key_from_db = Users.get_api_key_for_user(api_key.prefix)

    assert api_key_from_db.prefix == api_key.prefix
  end

  test "list_api_keys_for_user" do
    user = insert(:user)
    assert Users.list_api_keys_for_user(user.id) == []
  end

  test "delete_api_key_for_user" do
    user = insert(:user)
    {:ok, api_key} = Users.create_api_key_for_user(%{user_id: user.id, name: "high"})
    Users.delete_api_key_for_user(api_key.id)

    assert Users.get_api_key_for_user(api_key.prefix) == nil
  end
end
