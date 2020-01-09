defmodule AppTemplateWeb.AppDomainRedirect do
  @moduledoc """
  If the hostname of the current request doesn't match the one configured
  on the endpoint, redirect... on GET requests only
  """
  import Plug.Conn
  alias AppTemplateWeb.Endpoint
  alias Phoenix.Controller

  @default_opts %{active: Mix.env() == :prod}

  def init(opts) do
    Map.merge(@default_opts, Enum.into(opts, %{}))
  end

  def call(%{method: "GET"} = conn, %{active: true}) do
    req_host = conn.host
    %{host: endpoint_host} = Endpoint.struct_url()

    if req_host == endpoint_host do
      conn
    else
      redirect_url = Endpoint.url() <> path(conn)

      conn
      |> Controller.redirect(external: redirect_url)
      |> halt()
    end
  end

  def call(conn, _), do: conn

  defp path(%{request_path: path, query_string: ""}), do: path

  defp path(%{request_path: path, query_string: query}) do
    "#{path}?#{query}"
  end
end
