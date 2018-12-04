defmodule AppTemplateWeb.FallbackController do
  use AppTemplateWeb, :controller

  def call(conn, :not_found) do
    conn
    |> put_status(404)
    |> put_view(AppTemplateWeb.ErrorView)
    |> render("404.html")
  end
end
