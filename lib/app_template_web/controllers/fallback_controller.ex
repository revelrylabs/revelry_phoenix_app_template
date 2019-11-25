defmodule MappConstructionWeb.FallbackController do
  use MappConstructionWeb, :controller

  def call(conn, :not_found) do
    conn
    |> put_status(404)
    |> put_view(MappConstructionWeb.ErrorView)
    |> render("404.html")
  end
end
