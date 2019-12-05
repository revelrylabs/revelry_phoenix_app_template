defmodule AppTemplate.Repo.Migrations.ApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add(:user_id, references(:users))
      add(:name, :string)
      add(:prefix, :string)
      add(:key_hash, :string)
      timestamps()
    end

    create(index(:api_keys, [:user_id]))
    create(unique_index(:api_keys, [:prefix, :key_hash]))
    create(unique_index(:api_keys, [:user_id, "lower(name)"]))
  end
end
