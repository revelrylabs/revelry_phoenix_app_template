defmodule AppTemplate.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias AppTemplate.{Repo, User, APIKey}

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
    update_admin_permissions(user, true)
  end

  def revoke_user_admin_permissions(user) do
    update_admin_permissions(user, false)
  end

  defp update_admin_permissions(user, admin?) do
    user_changeset = Changeset.change(user, admin: admin?)
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
end
