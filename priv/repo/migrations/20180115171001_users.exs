defmodule AppTemplate.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:password, :string)
      timestamps()
    end

    create(unique_index(:users, ["lower(email)"]))
  end
end
