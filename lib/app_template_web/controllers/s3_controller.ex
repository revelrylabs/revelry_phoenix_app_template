defmodule AppTemplateWeb.S3Controller do
  use AppTemplateWeb, :controller
  alias Ecto.UUID
  @s3_signer Application.get_env(:app_template, :s3_signer)

  def sign(conn, %{"file_name" => original_file_name}) do
    uri = URI.parse(original_file_name)

    uuid = UUID.generate()

    extension =
      uri.path
      |> Path.extname()
      |> String.downcase()

    basename =
      uri.path
      |> Path.basename(extension)
      |> String.downcase()

    new_file_name = "#{basename}-#{uuid}#{extension}"
    result = @s3_signer.get_presigned_url(new_file_name)

    case result do
      {:ok, signed_url} ->
        bucket = Application.get_env(:app_template, :s3_bucket)

        response = %{
          data: %{
            signed_request: signed_url,
            file_name: new_file_name,
            file_type: MIME.type(String.replace_leading(extension, ".", "")),
            url: "https://s3.amazonaws.com/#{bucket}/uploads/#{new_file_name}"
          }
        }

        json(conn, response)

      _ ->
        error = %{
          errors: %{
            "all" => ["Unauthorized"]
          }
        }

        conn
        |> put_status(400)
        |> json(error)
    end
  end

  def sign(conn, _params) do
    error = %{
      errors: %{
        "all" => ["Invalid request"]
      }
    }

    conn
    |> put_status(400)
    |> json(error)
  end
end
