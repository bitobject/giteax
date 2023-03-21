defmodule Giteax.Organization.Schemas.TeamListRequestParams do
  @moduledoc """
  Gitea: request schema for repo creation
  """
  use Ecto.Schema

  @fields ~w(page limit)a
  @required_fields ~w()a
  @derive {Jason.Encoder, only: @fields}
  @primary_key false

  @type t() :: %__MODULE__{
          page: boolean(),
          limit: String.t()
        }

  schema "team_list_requests_params" do
    field(:page, :integer, default: 1)
    field(:limit, :integer, default: 50)
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

  @spec from_struct(t()) :: %{page: integer(), limit: integer()}
  def from_struct(struct), do: Map.take(struct, @fields)

  @spec change(map()) :: Ecto.Changeset.t(t())
  defp change(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end
