defmodule Giteax.Organization.Schemas.TeamRequestParams do
  @moduledoc """
  Gitea: request schema for ogranization creation
  """

  use Ecto.Schema

  @fields ~w(can_create_org_repo description includes_all_repositories name permission units)a
  @required_fields ~w(name)a
  @derive {Jason.Encoder, only: @fields}
  @primary_key false
  @unit_values ~w(repo.code repo.issues repo.ext_issues repo.wiki repo.pulls repo.releases repo.projects repo.ext_wiki)a

  @type t() :: %__MODULE__{
          can_create_org_repo: boolean(),
          description: String.t(),
          includes_all_repositories: boolean(),
          name: String.t(),
          permission: :read | :write | :admin,
          units:
            list(
              :"repo.code"
              | :"repo.issues"
              | :"repo.ext_issues"
              | :"repo.wiki"
              | :"repo.pulls"
              | :"repo.releases"
              | :"repo.projects"
              | :"repo.ext_wiki"
            )
        }

  schema "organization_request_params" do
    field(:can_create_org_repo, :boolean, default: true)
    field(:description, :string)
    field(:includes_all_repositories, :boolean, default: true)
    field(:name, :string)
    field(:permission, Ecto.Enum, values: ~w(read write admin)a, default: :admin)
    field(:units, {:array, Ecto.Enum}, values: @unit_values)
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

  @spec change(%{required(:name) => String.t()}) :: Ecto.Changeset.t(t())
  def change(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end
