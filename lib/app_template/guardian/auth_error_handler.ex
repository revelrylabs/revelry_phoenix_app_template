defmodule AppTemplate.Guardian.ErrorHandler do
  @moduledoc """
  This is a fallback module for Guardian errors. If pipeline fails, we'll fallback here.
  """
  import Plug.Conn

  use AppTemplateWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @doc false
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(403)
    |> put_view(AppTemplateWeb.ErrorView)
    |> render("403.html")
  end
end
