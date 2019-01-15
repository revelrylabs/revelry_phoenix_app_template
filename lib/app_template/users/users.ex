defmodule AppTemplate.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias AppTemplate.{Repo, User}

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
end
