defmodule Giteax.Organization.Schemas.Team do
  @moduledoc """
  Ogranization struct.
  """

  use Ecto.Schema

  alias Giteax.Organization.Schemas.Org

  @behaviour Giteax.Module
  @fields ~w(can_create_org_repo description id includes_all_repositories name permission units)a
  @unit_values ~w(repo.code repo.issues repo.ext_issues repo.wiki repo.pulls repo.releases repo.projects repo.ext_wiki)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          can_create_org_repo: boolean(),
          description: String.t(),
          id: integer(),
          includes_all_repositories: boolean(),
          name: String.t(),
          permission: :none | :read | :write | :admin | :owner,
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

  embedded_schema do
    field(:can_create_org_repo, :boolean)
    field(:description, :string)
    field(:id, :integer)
    field(:includes_all_repositories, :boolean)
    field(:name, :string)
    field(:permission, Ecto.Enum, values: ~w(none read write admin owner)a)
    field(:units, {:array, Ecto.Enum}, values: @unit_values)

    embeds_one :organization, Org
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    organization = Org.parse(params["organization"])

    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.put_embed(:organization, organization)
    |> Ecto.Changeset.apply_changes()
  end

  @impl Giteax.Module
  def parse_list(nil), do: []
  def parse_list([]), do: []

  def parse_list(list) do
    for params <- list do
      organization = Org.parse(params["organization"])

      %__MODULE__{}
      |> Ecto.Changeset.cast(params, @fields)
      |> Ecto.Changeset.put_embed(:organization, organization)
      |> Ecto.Changeset.apply_changes()
    end
  end
end
