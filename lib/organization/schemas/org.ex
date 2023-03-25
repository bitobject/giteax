defmodule Giteax.Organization.Schemas.Org do
  @moduledoc """
  Ogranization struct.
  """

  use Ecto.Schema

  @behaviour Giteax.Module
  @fields ~w(avatar_url description full_name id location repo_admin_change_team_access username visibility website)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          avatar_url: String.t(),
          description: String.t(),
          full_name: String.t(),
          id: integer(),
          location: String.t(),
          repo_admin_change_team_access: boolean(),
          username: String.t(),
          visibility: String.t(),
          website: String.t()
        }

  embedded_schema do
    field(:avatar_url, :string)
    field(:description, :string)
    field(:full_name, :string)
    field(:id, :integer)
    field(:location, :string)
    field(:repo_admin_change_team_access, :boolean)
    field(:username, :string)
    field(:visibility, Ecto.Enum, values: ~w(public limited private)a)
    field(:website, :string)
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end
end
