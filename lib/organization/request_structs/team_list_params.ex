defmodule Giteax.Organization.RequestStructs.TeamListParams do
  @moduledoc """
  Gitea: request schema for repo creation
  """
  use Ecto.Schema

  @fields ~w(page limit)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{page: boolean(), limit: String.t()}

  embedded_schema do
    field(:page, :integer, default: 1)
    field(:limit, :integer, default: 50)
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

  @spec to_list(t()) :: [page: integer(), limit: integer()]
  def to_list(struct) do
    struct
    |> Map.take(@fields)
    |> Map.to_list()
  end

  @spec change(map()) :: Ecto.Changeset.t(t())
  def change(params), do: Ecto.Changeset.cast(%__MODULE__{}, params, @fields)
end
