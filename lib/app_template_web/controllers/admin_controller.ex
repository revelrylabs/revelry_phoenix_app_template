defmodule AppTemplateWeb.AdminController do
  use AppTemplateWeb, :controller

  @models %{
    "user" => {AppTemplate.User, [exclude: [:password]]}
  }

  def index(conn, %{"schema" => schema}) do
    {schema_module, [exclude: excluded_fields]} = @models[schema]

    fields =
      Enum.filter(schema_module.__schema__(:fields), fn field -> field not in excluded_fields end)

    models = AppTemplate.Repo.all(schema_module)

    opts = [
      schema_module: schema_module,
      schema: schema,
      models: models,
      fields: fields
    ]

    render(conn, "index.html", opts)
  end

  # def new(conn, %{"schema" => schema}) do
  #   schema_module = @models[schema]

  #   model =
  #     schema_module.__schema__(:associations)
  #     |> Enum.reduce(AppTemplate.Repo.get(m, pk), fn a, m ->
  #       AppTemplate.Repo.preload(m, a)
  #     end)

  #   # TODO: load changeset from session?
  #   opts = [
  #     changeset: Ecto.Changeset.change(model, %{}),
  #     schema_module: schema_module,
  #     schema: schema,
  #     pk: pk
  #   ]

  #   render(conn, "edit.html", opts)
  # end

  # def create(conn, %{"schema" => schema, "pk" => pk, "data" => data}) do
  #   schema_module = @models[schema]

  #   # TODO: be wary! this lets an admin change EVERYTHING!
  #   # if you want to avoid this like I did, setup an AdminEditable protocol that
  #   # requires your schema to implement an admin-specific changeset and use that
  #   # instead
  #   changeset = Ecto.Changeset.change(AppTemplate.Repo.get!(module, pk), data)

  #   case AppTemplate.Repo.update(changeset) do
  #     {:ok, updated_model} ->
  #       conn
  #       |> put_flash(:info, "#{String.capitalize(schema)} ID #{pk} updated!")
  #       |> redirect(to: Routes.admin_path(conn, :edit, schema, pk))

  #     {:error, changeset} ->
  #       conn
  #       |> put_flash(:failed, "#{String.capitalize(schema)} ID #{pk} failed to update!")
  #       |> put_session(:changeset, changeset)
  #       |> redirect(to: Routes.admin_path(conn, :edit, schema, pk))
  #   end
  # end

  # def edit(conn, %{"schema" => schema, "pk" => pk}) do
  #   schema_module = @models[schema]

  #   model =
  #     schema_module.__schema__(:associations)
  #     |> Enum.reduce(AppTemplate.Repo.get(m, pk), fn a, m ->
  #       AppTemplate.Repo.preload(m, a)
  #     end)

  #   # TODO: load changeset from session?
  #   opts = [
  #     changeset: Ecto.Changeset.change(model, %{}),
  #     schema_module: schema_module,
  #     schema: schema,
  #     pk: pk
  #   ]

  #   render(conn, "edit.html", opts)
  # end

  # def update(conn, %{"schema" => schema, "pk" => pk, "data" => data}) do
  #   schema_module = @models[schema]

  #   # TODO: be wary! this lets an admin change EVERYTHING!
  #   # if you want to avoid this like I did, setup an AdminEditable protocol that
  #   # requires your schema to implement an admin-specific changeset and use that
  #   # instead
  #   changeset = Ecto.Changeset.change(AppTemplate.Repo.get!(module, pk), data)

  #   case AppTemplate.Repo.update(changeset) do
  #     {:ok, updated_model} ->
  #       conn
  #       |> put_flash(:info, "#{String.capitalize(schema)} ID #{pk} updated!")
  #       |> redirect(to: Routes.admin_path(conn, :edit, schema, pk))

  #     {:error, changeset} ->
  #       conn
  #       |> put_flash(:failed, "#{String.capitalize(schema)} ID #{pk} failed to update!")
  #       |> put_session(:changeset, changeset)
  #       |> redirect(to: Routes.admin_path(conn, :edit, schema, pk))
  #   end
  # end
end
