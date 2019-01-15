defmodule AppTemplate.Repo.Migrations.AddAdminToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:admin, :boolean, default: false)
    end

    create(index(:users, [:admin]))
  end
end
