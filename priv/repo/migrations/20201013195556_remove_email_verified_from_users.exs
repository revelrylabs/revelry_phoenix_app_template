defmodule AppTemplate.Repo.Migrations.RemoveEmailVerifiedFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:email_verified)
    end
  end
end
