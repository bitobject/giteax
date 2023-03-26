defmodule Giteax.Organization.Schemas.ExternalWiki do
  @moduledoc """
  External Wiki struct.
  """

  use Ecto.Schema

  @behaviour Giteax.ReponseFiller
  @fields ~w(external_wiki_url)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{external_wiki_url: String.t()}

  embedded_schema do
    field(:external_wiki_url, :string)
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
