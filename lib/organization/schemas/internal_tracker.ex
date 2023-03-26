defmodule Giteax.Organization.Schemas.InternalTracker do
  @moduledoc """
  Internal Tracker struct.
  """

  use Ecto.Schema

  @behaviour Giteax.Module
  @fields ~w(allow_only_contributors_to_track_time enable_issue_dependencies enable_time_tracker)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          allow_only_contributors_to_track_time: boolean(),
          enable_issue_dependencies: boolean(),
          enable_time_tracker: boolean()
        }

  embedded_schema do
    field(:allow_only_contributors_to_track_time, :boolean)
    field(:enable_issue_dependencies, :boolean)
    field(:enable_time_tracker, :boolean)
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end

  @impl Giteax.Module
  def parse_list(nil), do: []
  def parse_list([]), do: []

  def parse_list(list) do
    for params <- list do
      %__MODULE__{}
      |> Ecto.Changeset.cast(params, @fields)
      |> Ecto.Changeset.apply_changes()
    end
  end
end
