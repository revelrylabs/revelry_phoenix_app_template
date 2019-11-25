defmodule MappConstruction.Factory do
  alias MappConstruction.{Repo}
  use ExMachina.Ecto, repo: Repo
  alias MappConstruction.Generators

  def user_factory do
    Generators.generate(:user)
  end
end
