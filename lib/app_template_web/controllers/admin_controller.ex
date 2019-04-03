defmodule AppTemplateWeb.AdminController do
  use AppTemplateWeb, :controller

  @schemas %{
    "user" => AppTemplate.User
  }

  def index(conn, %{"schema" => schema} = params) do
    schema_module = @schemas[schema]

    page = AppTemplate.Repo.paginate(schema_module, params)

    schemas = AppTemplate.Repo.all(schema_module)

    opts = [
      schema_module: schema_module,
      schema: schema,
      schemas: schemas,
      schemas: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    ]

    render(conn, "index.html", opts)
  end

  def new(conn, %{"schema" => schema}) do
    schema_module = @schemas[schema]

    model = struct(schema_module)

    opts = [
      changeset: Ecto.Changeset.change(model, %{}),
      schema_module: schema_module,
      schema: schema
    ]

    render(conn, "new.html", opts)
  end

  def create(conn, %{"schema" => schema, "data" => data}) do
    schema_module = @schemas[schema]

    new_schema = struct(schema_module)

    changeset =
      Ecto.Changeset.cast(new_schema, data, AppTemplateWeb.Adminable.editable_fields(new_schema))

    case AppTemplate.Repo.insert(changeset) do
      {:ok, created} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} created!")
        |> redirect(to: Routes.admin_path(conn, :edit, schema, created.id))

      {:error, changeset} ->
        opts = [
          changeset: changeset,
          schema_module: schema_module,
          schema: schema
        ]

        conn
        |> put_flash(:failed, "#{String.capitalize(schema)} failed to create!")
        |> put_status(:unprocessable_entity)
        |> render("new.html", opts)
    end
  end

  def edit(conn, %{"schema" => schema, "pk" => pk}) do
    schema_module = @schemas[schema]

    model =
      schema_module.__schema__(:associations)
      |> Enum.reduce(AppTemplate.Repo.get(schema_module, pk), fn a, m ->
        AppTemplate.Repo.preload(m, a)
      end)

    opts = [
      changeset: Ecto.Changeset.change(model, %{}),
      schema_module: schema_module,
      schema: schema,
      pk: pk
    ]

    render(conn, "edit.html", opts)
  end

  def update(conn, %{"schema" => schema, "pk" => pk, "data" => data}) do
    schema_module = @schemas[schema]

    changeset = Ecto.Changeset.change(AppTemplate.Repo.get!(schema_module, pk), data)

    case AppTemplate.Repo.update(changeset) do
      {:ok, _updated_model} ->
        conn
        |> put_flash(:info, "#{String.capitalize(schema)} ID #{pk} updated!")
        |> redirect(to: Routes.admin_path(conn, :edit, schema, pk))

      {:error, changeset} ->
        opts = [
          changeset: changeset,
          schema_module: schema_module,
          schema: schema,
          pk: pk
        ]

        conn
        |> put_flash(:failed, "#{String.capitalize(schema)} ID #{pk} failed to update!")
        |> put_status(:unprocessable_entity)
        |> render("edit.html", opts)
    end
  end
end
