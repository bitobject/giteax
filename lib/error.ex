defmodule Giteax.Error do
  @moduledoc """
  External Tracker struct.
  """

  use Ecto.Schema

  @fields ~w(errors message url)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          errors: list(),
          message: String.t(),
          url: String.t()
        }

  embedded_schema do
    field(:errors, {:array, :string})
    field(:message, :string)
    field(:url, :string)
  end

  @spec parse(%{
          required(:errors) => list(),
          required(:message) => list(),
          required(:url) => list()
        }) :: t()
  def parse(params) when is_map(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end

  def parse(errors), do: errors
end
