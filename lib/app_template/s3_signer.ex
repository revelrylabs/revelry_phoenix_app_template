defmodule AppTemplate.S3Signer do
  @moduledoc """
  Signs S3 requests
  """
  alias ExAws.{Config, S3}

  def get_presigned_url(new_file_name) do
    bucket = Application.get_env(:app_template, :s3_bucket)
    s3_config = Config.new(:s3)

    S3.presigned_url(s3_config, :put, bucket, "uploads/" <> new_file_name)
  end
end
