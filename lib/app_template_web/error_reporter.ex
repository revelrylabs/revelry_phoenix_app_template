defmodule AppTemplateWeb.ErrorReporter do
  @moduledoc """
  Takes care of reporting router errors.
  """
  alias Plug.Conn
  alias AppTemplate.Scrubber
  require Logger

  @ignore_error_routes [
    "/favicon.ico"
  ]

  # ignore errors for paths that have no reason to exist
  def handle_errors(%{request_path: request_path}, _)
      when request_path in @ignore_error_routes do
    nil
  end

  # Write to logs instead of triggering Rollbar on 404s
  # the message looks like `404: no route found for GET /bad-url (AppTemplateWeb.Router)`
  def handle_errors(_conn, %{reason: %Phoenix.Router.NoRouteError{} = reason}) do
    Logger.info("404: #{reason.message}")
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Conn.fetch_cookies()
      |> Conn.fetch_query_params()

    conn_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
        "headers" => Enum.into(conn.req_headers, %{}),
        "params" => Scrubber.scrub(conn.params),
        "method" => conn.method
      }
    }

    conn_data =
      case conn do
        %{assigns: %{current_user: %{id: id, email: email}}} ->
          conn_data
          |> Map.put("person", %{
            "id" => to_string(id),
            "email" => email
          })

        _ ->
          conn_data
      end

    Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
  end
end
