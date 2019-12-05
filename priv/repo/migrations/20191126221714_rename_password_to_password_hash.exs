defmodule AppTemplate.Repo.Migrations.RenamePasswordToPasswordHash do
  use Ecto.Migration

  def change do
    rename(table("users"), :password, to: :password_hash)
  end
end
