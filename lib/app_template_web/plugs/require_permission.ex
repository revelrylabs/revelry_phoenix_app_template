defmodule AppTemplateWeb.RequirePermission do
  @moduledoc """
  Ensures the user has permssion to access the resource
  """

  import Plug.Conn
  alias AppTemplate.{User, Users}

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _) do
    conn
    |> put_status(:forbidden)
    |> Phoenix.Controller.put_view(AppTemplateWeb.ErrorView)
    |> Phoenix.Controller.render(:"403")
    |> halt()
  end

  def call(%Plug.Conn{assigns: %{current_user: user = %User{}}} = conn,
        permission: permission
      ) do
    if Users.user_has_permission?(user, permission) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> Phoenix.Controller.put_view(AppTemplateWeb.ErrorView)
      |> Phoenix.Controller.render(:"403")
      |> halt()
    end
  end
end
