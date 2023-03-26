defmodule Giteax.Organization.Schemas.Permission do
  @moduledoc """
  Permission struct.
  """

  use Ecto.Schema

  @behaviour Giteax.ReponseFiller
  @fields ~w(admin pull push)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          admin: boolean(),
          pull: boolean(),
          push: boolean()
        }

  embedded_schema do
    field(:admin, :boolean)
    field(:pull, :boolean)
    field(:push, :boolean)
  end

  @impl Giteax.ReponseFiller
  def process(nil), do: nil

  def process(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end

  @impl Giteax.ReponseFiller
  def process_list(nil), do: []
  def process_list([]), do: []

  def process_list(list) do
    for params <- list do
      %__MODULE__{}
      |> Ecto.Changeset.cast(params, @fields)
      |> Ecto.Changeset.apply_changes()
    end
  end
end
