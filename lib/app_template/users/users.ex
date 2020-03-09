defmodule AppTemplate.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias AppTemplate.{Repo, User, APIKey, Role}

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: String.downcase(email))
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def grant_user_admin_permissions(user) do
    update_admin_permissions(user, "admin")
  end

  def revoke_user_admin_permissions(user) do
    update_admin_permissions(user, "user")
  end

  defp update_admin_permissions(user, role) do
    user_changeset = Changeset.change(user, role: role)
    Repo.update(user_changeset)
  end

  def create_api_key_for_user(params) do
    %APIKey{}
    |> APIKey.create_changeset(params)
    |> Repo.insert()
  end

  def update_api_key_for_user(api_key, params) do
    api_key
    |> APIKey.update_changeset(params)
    |> Repo.update()
  end

  def get_api_key_for_user(prefix) do
    APIKey
    |> where([api_key], api_key.prefix == ^prefix)
    |> preload(:user)
    |> Repo.one()
  end

  def list_api_keys_for_user(user_id) do
    APIKey
    |> where([api_key], api_key.user_id == ^user_id)
    |> Repo.all()
  end

  def delete_api_key_for_user(api_key_id) do
    APIKey
    |> Repo.get(api_key_id)
    |> Repo.delete()
  end

  def user_has_permission?(user = %User{}, permission) do
    permission = if is_bitstring(permission), do: String.to_atom(permission), else: permission
    Role.has_permission?(user.role, permission)
  end
end
