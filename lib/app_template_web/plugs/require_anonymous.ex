defmodule MappConstructionWeb.RequireAnonymous do
  @moduledoc """
  Ensures user is signed out
  """

  import Plug.Conn
  alias MappConstructionWeb.Router.Helpers, as: Routes

  def init(opts) do
    opts
  end

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _), do: conn

  def call(conn, _) do
    to_path = Routes.page_path(conn, :index)

    conn
    |> Phoenix.Controller.redirect(to: to_path)
    |> halt()
  end
end
