defmodule Giteax.Organization.Schemas.RepoRequestParams do
  @moduledoc """
  Gitea: request schema for repo creation
  """
  use Ecto.Schema

  @fields ~w(auto_init default_branch description gitignores issue_labels license name private readme template trust_model)a
  @required_fields ~w(name)a
  @derive {Jason.Encoder, only: @fields}
  @primary_key false

  @type t() :: %__MODULE__{
          auto_init: boolean(),
          default_branch: String.t(),
          description: String.t(),
          gitignores: String.t(),
          issue_labels: String.t(),
          license: String.t(),
          name: String.t(),
          private: boolean(),
          readme: String.t(),
          template: boolean(),
          trust_model: :default | :collaborator | :committer | :collaboratorcommitter
        }

  schema "repo_request_params" do
    field(:auto_init, :boolean, default: true)
    field(:default_branch, :string)
    field(:description, :string)
    field(:gitignores, :string)
    field(:issue_labels, :string)
    field(:license, :string)
    field(:name, :string)
    field(:private, :boolean, default: true)
    field(:readme, :string)
    field(:template, :boolean, default: false)

    field(:trust_model, Ecto.Enum,
      values: [:default, :collaborator, :committer, :collaboratorcommitter],
      default: :default
    )
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

  @spec change(%{required(:name) => String.t()}) :: Ecto.Changeset.t(t())
  defp change(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end
