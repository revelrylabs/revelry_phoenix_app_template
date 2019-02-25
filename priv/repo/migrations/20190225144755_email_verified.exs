defmodule AppTemplate.Repo.Migrations.EmailVerified do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:email_verified, :boolean, default: false)
    end

    create(index(:users, [:email_verified]))
  end
end
