defmodule Mix.Tasks.Ecto.Gen.Trigger do
  @moduledoc """
  Creates trigger migrations and keeps track of the versions in a separate
  directory to find them easily. When it is first run for a new trigger, a
  new migration is generated, some boilerplate code is added to it and a
  symlink is created for v1 of the trigger in the priv/repo/migrations/triggers
  directory.

  On subsequent calls, the up and down functions of the new migration are set to
  the up function of the previous version. This is so that rollbacks are easy
  and because we usually start from a previous version of the trigger when
  making a new version.

  usage:

    mix ecto.gen.trigger <trigger_name>
  """

  @shortdoc "Generate database trigger migrations"

  use Mix.Task

  @migration_dir "priv/repo/migrations"
  @trigger_dir Path.join([File.cwd!(), @migration_dir, "triggers"])

  def run([]) do
    IO.puts("Usage: mix ecto.gen.trigger <trigger_name>")
  end

  def run([trigger_name]) do
    unless File.exists?(@trigger_dir) do
      File.mkdir(@trigger_dir)
    end

    latest_version =
      @trigger_dir
      |> File.ls!()
      |> Enum.filter(fn path -> path =~ ~r/^#{trigger_name}_v\d+.exs/ end)
      |> Enum.sort()
      |> List.last()

    if latest_version do
      create_next_version(trigger_name, latest_version)
    else
      create_first_version(trigger_name)
    end
  end

  defp create_first_version(trigger_name) do
    next_version_file = Path.join(@trigger_dir, "#{trigger_name}_v1.exs")

    new_migration_file = generate_migration(trigger_name, 1)

    File.ln_s(Path.join("..", new_migration_file), next_version_file)

    {:ok, new_file_contents} = File.read(next_version_file)

    updated_migration =
      Regex.replace(~r/\n.*def change(.|\n)*?end/m, new_file_contents, boilerplate_code())

    File.write(next_version_file, updated_migration)
  end

  # This could be a moduledoc but that would push the rest of the code down and
  # make it overall harder to read
  defp boilerplate_code do
    ~S|
  def up do
    execute(
      """
      CREATE OR REPLACE FUNCTION !FUNCTION_NAME()
      RETURNS trigger AS $$
      BEGIN
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
      """
    )

    execute(
      """
      CREATE TRIGGER !TRIGGER_NAME
      AFTER INSERT OR UPDATE
      ON !TABLE_NAME
      FOR EACH ROW
      EXECUTE PROCEDURE !FUNCTION_NAME()
      """
    )
  end

  def down do
    execute "drop trigger if exists !TRIGGER_NAME on !TABLE_NAME"
    execute "drop function if exists !FUNCTION_NAME()"
  end|
  end

  defp create_next_version(trigger_name, latest_version) do
    [_, latest_version_number] = Regex.run(~r/v(\d+)\.exs$/, latest_version)
    next_version_number = String.to_integer(latest_version_number) + 1
    next_version_file = Path.join(@trigger_dir, "#{trigger_name}_v#{next_version_number}.exs")

    new_migration_file = generate_migration(trigger_name, next_version_number)

    # Create a symlink to the migration relative to the triggers directory
    File.ln_s(Path.join("..", new_migration_file), next_version_file)

    {:ok, new_file_contents} = File.read(next_version_file)
    {:ok, latest_file_contents} = File.read(Path.join(@trigger_dir, latest_version))
    [latest_up | _] = Regex.run(~r/\n.*def up(.|\n)*?end/m, latest_file_contents)
    latest_down = String.replace(latest_up, "def up", "def down")

    new_code = "#{latest_up}\n#{latest_down}"

    updated_migration = Regex.replace(~r/\n.*def change(.|\n)*?end/m, new_file_contents, new_code)
    File.write(next_version_file, updated_migration)
  end

  defp generate_migration(trigger_name, version) do
    # We have to pass in the repo because we didn't start the app
    Mix.Task.run("ecto.gen.migration", ["#{trigger_name}_v#{version}", "--repo AppTemplate.Repo"])

    @migration_dir
    |> File.ls!()
    |> Enum.find(fn path -> path =~ ~r/^\d+_#{trigger_name}_v#{version}.exs$/ end)
  end
end
