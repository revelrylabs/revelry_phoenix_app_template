defmodule AppTemplateWeb.ErrorReporter do
  @moduledoc """
  Takes care of reporting router errors.
  """
  alias Plug.Conn
  @filtered_params ["password"]
  @ignore_error_routes [
    "/wp-login.php",
    "/favicon.ico"
  ]

  # ignore errors for paths that have no reason to exist
  def handle_errors(%{request_path: request_path}, _)
      when request_path in @ignore_error_routes do
    nil
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    if Application.get_env(:rollbax, :access_token) do
      conn =
        conn
        |> Conn.fetch_cookies()
        |> Conn.fetch_query_params()

      params =
        for {key, _value} = tuple <- conn.params, into: %{} do
          if key in @filtered_params do
            {key, "[FILTERED]"}
          else
            tuple
          end
        end

      conn_data = %{
        "request" => %{
          "cookies" => conn.req_cookies,
          "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
          "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
          "headers" => Enum.into(conn.req_headers, %{}),
          "params" => params,
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
end
