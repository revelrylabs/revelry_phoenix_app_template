defmodule AppTemplate.Repo do
  use Ecto.Repo, otp_app: :app_template, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, opts}
  end
end
