defmodule AppTemplate.ReleaseTasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @app :app_template
  @repos Application.get_env(@app, :ecto_repos, [])

  def migrate() do
    start_services()

    run_migrations()

    stop_services()
  end

  def seed() do
    start_services()

    run_migrations()

    run_seeds()

    stop_services()
  end

  def grant_admin([email]) do
    start_services()

    grant_admin_permissions(email)

    stop_services()
  end

  def revoke_admin([email]) do
    start_services()

    revoke_admin_access(email)

    stop_services()
  end

  defp start_services do
    IO.puts("Loading #{@app}..")

    # Load the code for myapp, but don't start it
    Application.load(@app)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for app
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations do
    Enum.each(@repos, &run_migrations_for/1)
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    migrations_path = priv_path_for(repo, "migrations")
    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp run_seeds do
    Enum.each(@repos, &run_seeds_for/1)
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = priv_path_for(repo, "seeds.exs")

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end

  def grant_admin_permissions(email) do
    user = AppTemplate.Users.get_user_by_email(email)

    if user do
      case AppTemplate.Users.grant_user_admin_permissions(user) do
        {:ok, _} ->
          IO.puts("User<#{email}> is now an admin")

        _ ->
          IO.puts("Unable to make User<#{email}> into an admin")
      end
    else
      IO.puts("Unable to find User<#{email}>")
    end
  end

  def revoke_admin_access(email) do
    user = AppTemplate.Users.get_user_by_email(email)

    if user do
      case AppTemplate.Users.revoke_user_admin_permissions(user) do
        {:ok, _} ->
          IO.puts("User<#{email}> admin access revoked")

        _ ->
          IO.puts("Unable to revoke User<#{email}> admin access")
      end
    else
      IO.puts("Unable to find User<#{email}>")
    end
  end
end
