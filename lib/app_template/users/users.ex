defmodule MappConstruction.Users do
  @moduledoc """
  Module for interacting with Users
  """

  import Ecto.{Query}, warn: false
  alias Ecto.Changeset
  alias MappConstruction.{Repo, User}

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

  def update_user_account_details(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_password_for_user(user, params) do
    user
    |> User.update_password_changeset(params)
    |> Repo.update()
  end

  def update_password_for_user_forgot(user, params) do
    user
    |> User.forgot_password_changeset(params)
    |> Repo.update()
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

  def update_email_verified(user) do
    user_changeset = Changeset.change(user, email_verified: true)
    Repo.update(user_changeset)
  end
end
