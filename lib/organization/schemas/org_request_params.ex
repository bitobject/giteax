defmodule Giteax.Organization.Schemas.OrgRequestParams do
  @moduledoc """
  Gitea: request schema for ogranization creation
  """
  use Ecto.Schema

  @fields ~w(description full_name location repo_admin_change_team_access username visibility website)a
  @required_fields ~w(username)a
  @derive {Jason.Encoder, only: @fields}
  @primary_key false

  @type t() :: %__MODULE__{
          description: String.t(),
          full_name: String.t(),
          location: String.t(),
          repo_admin_change_team_access: boolean(),
          username: String.t(),
          visibility: :public | :limited | :private,
          website: String.t()
        }

  schema "organization_request_params" do
    field(:description, :string)
    field(:full_name, :string)
    field(:location, :string)
    field(:repo_admin_change_team_access, :boolean, default: true)
    field(:username, :string)
    field(:visibility, Ecto.Enum, values: [:public, :limited, :private], default: :public)
    field(:website, :string)
  end

  @spec validate(map()) :: {:ok, t()} | {:error, Keyword.t()}
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
  end
end
