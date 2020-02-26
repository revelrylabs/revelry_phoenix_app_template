defmodule AppTemplate.Role do
  @moduledoc """
  A struct representating a role in the system.

  A role is a set of permissions
  """

  @type t :: %__MODULE__{}
  defstruct [:name, :permissions]

  @permissions [
    :update_profile,
    :administrator
  ]

  @spec admin :: Mold.Role.t()
  def admin,
    do: %__MODULE__{
      name: "admin",
      permissions: @permissions
    }

  def user,
    do: %__MODULE__{
      name: "user",
      permissions: [
        :update_profile
      ]
    }

  def roles do
    [
      admin(),
      user()
    ]
  end

  @spec has_permission?(String.t() | t(), atom()) :: boolean()
  def has_permission?(role, permission)

  def has_permission?(role, permission) when is_bitstring(role) do
    has_permission?(get_role_by_name(role), permission)
  end

  def has_permission?(role = %__MODULE__{}, permission), do: permission in role.permissions

  defp get_role_by_name("admin"), do: admin()
  defp get_role_by_name("user"), do: user()
end
