defmodule AppTemplate.S3Signer.Mock do
  @moduledoc """
  Mock Signs S3 requests
  """

  def get_presigned_url(new_file_name) do
    if String.contains?(new_file_name, ".bad") do
      :error
    else
      {:ok, "https://s3.amazonaws.com/app_template/#{new_file_name}"}
    end
  end
end
