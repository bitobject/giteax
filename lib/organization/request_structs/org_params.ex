defmodule Giteax.Organization.RequestStructs.OrgParams do
  @moduledoc """
  Gitea: request schema for ogranization creation
  """
  use Ecto.Schema

  @fields ~w(description full_name location repo_admin_change_team_access username visibility website)a
  @required_fields ~w(username)a
  @derive Jason.Encoder
  @primary_key false
  @website_regex ~r/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/

  @type t() :: %__MODULE__{
          description: String.t(),
          full_name: String.t(),
          location: String.t(),
          repo_admin_change_team_access: boolean(),
          username: String.t(),
          visibility: :public | :limited | :private,
          website: String.t()
        }

  embedded_schema do
    field(:description, :string)
    field(:full_name, :string)
    field(:location, :string)
    field(:repo_admin_change_team_access, :boolean, default: true)
    field(:username, :string)
    field(:visibility, Ecto.Enum, values: ~w(public limited private)a, default: :public)
    field(:website, :string)
  end

  @spec validate(map()) :: {:ok, t()} | {:error, [{atom(), Ecto.Changeset.error()}]}
  def validate(params) do
    case change(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}

      %Ecto.Changeset{errors: errors} ->
        {:error, errors}
    end
  end

  @spec apply(Ecto.Changeset.t(t())) :: t()
  def apply(changeset), do: Ecto.Changeset.apply_changes(changeset)

  @spec change(%{required(:username) => String.t()}) :: Ecto.Changeset.t(t())
  def change(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.validate_required(@required_fields)
    |> Ecto.Changeset.validate_format(:website, @website_regex)
  end
end
