defmodule AppTemplate.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:admin)
      add(:role, :string)
    end

    create(index(:users, [:role]))
  end
end
