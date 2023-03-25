defmodule Giteax.Organization.Schemas.ExternalTracker do
  @moduledoc """
  External Tracker struct.
  """

  use Ecto.Schema

  @behaviour Giteax.Module
  @fields ~w(external_tracker_format external_tracker_style external_tracker_url)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          external_tracker_format: String.t(),
          external_tracker_style: String.t(),
          external_tracker_url: String.t()
        }

  embedded_schema do
    field(:external_tracker_format, :string)
    field(:external_tracker_style, :string)
    field(:external_tracker_url, :string)
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end
end
