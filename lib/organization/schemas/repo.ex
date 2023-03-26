defmodule Giteax.Organization.Schemas.Repo do
  @moduledoc """
  Ogranization struct.
  """

  use Ecto.Schema

  alias Giteax.Organization.Schemas.ExternalTracker
  alias Giteax.Organization.Schemas.ExternalWiki
  alias Giteax.Organization.Schemas.InternalTracker
  alias Giteax.Admin.Schemas.User
  alias Giteax.Organization.Schemas.Permission

  @behaviour Giteax.Module
  @fields ~w(allow_merge_commits allow_rebase allow_rebase_explicit allow_squash_merge archived avatar_url clone_url created_at default_branch default_merge_style description empty fork forks_count full_name has_issues has_projects has_pull_requests has_wiki html_url id ignore_whitespace_conflicts internal mirror mirror_interval name open_issues_count open_pr_counter original_url parent private release_counter size ssh_url stars_count template updated_at watchers_count website)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          allow_merge_commits: boolean(),
          allow_rebase: boolean(),
          allow_rebase_explicit: boolean(),
          allow_squash_merge: boolean(),
          archived: boolean(),
          avatar_url: String.t(),
          clone_url: String.t(),
          created_at: DateTime.t(),
          default_branch: String.t(),
          default_merge_style: String.t(),
          description: String.t(),
          empty: boolean(),
          fork: boolean(),
          forks_count: integer(),
          full_name: String.t(),
          has_issues: boolean(),
          has_projects: boolean(),
          has_pull_requests: boolean(),
          has_wiki: boolean(),
          html_url: String.t(),
          id: integer(),
          ignore_whitespace_conflicts: boolean(),
          internal: boolean(),
          mirror: boolean(),
          mirror_interval: String.t(),
          name: String.t(),
          open_issues_count: integer(),
          open_pr_counter: integer(),
          original_url: String.t(),
          parent: String.t(),
          private: boolean(),
          release_counter: integer(),
          size: integer(),
          ssh_url: String.t(),
          stars_count: integer(),
          template: boolean(),
          updated_at: DateTime.t(),
          watchers_count: integer(),
          website: String.t(),
          external_tracker: ExternalTracker.t(),
          external_wiki: ExternalWiki.t(),
          internal_tracker: InternalTracker.t(),
          owner: User.t(),
          permissions: Permission.t()
        }

  embedded_schema do
    field(:allow_merge_commits, :boolean)
    field(:allow_rebase, :boolean)
    field(:allow_rebase_explicit, :boolean)
    field(:allow_squash_merge, :boolean)
    field(:archived, :boolean)
    field(:avatar_url, :string)
    field(:clone_url, :string)
    field(:created_at, :utc_datetime_usec)
    field(:default_branch, :string)
    field(:default_merge_style, :string)
    field(:description, :string)
    field(:empty, :boolean)
    field(:fork, :boolean)
    field(:forks_count, :integer)
    field(:full_name, :string)
    field(:has_issues, :boolean)
    field(:has_projects, :boolean)
    field(:has_pull_requests, :boolean)
    field(:has_wiki, :boolean)
    field(:html_url, :string)
    field(:id, :integer)
    field(:ignore_whitespace_conflicts, :boolean)
    field(:internal, :boolean)
    field(:mirror, :boolean)
    field(:mirror_interval, :string)
    field(:name, :string)
    field(:open_issues_count, :integer)
    field(:open_pr_counter, :integer)
    field(:original_url, :string)
    field(:parent, :string)
    field(:private, :boolean)
    field(:release_counter, :integer)
    field(:size, :integer)
    field(:ssh_url, :string)
    field(:stars_count, :integer)
    field(:template, :boolean)
    field(:updated_at, :utc_datetime_usec)
    field(:watchers_count, :integer)
    field(:website, :string)

    embeds_one :external_tracker, ExternalTracker
    embeds_one :external_wiki, ExternalWiki
    embeds_one :internal_tracker, InternalTracker
    embeds_one :owner, User
    embeds_one :permissions, Permission
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    external_tracker = ExternalTracker.parse(params["external_tracker"])
    external_wiki = ExternalWiki.parse(params["external_wiki"])
    internal_tracker = InternalTracker.parse(params["internal_tracker"])
    owner = User.parse(params["owner"])
    permissions = Permission.parse(params["permissions"])

    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.put_embed(:external_tracker, external_tracker)
    |> Ecto.Changeset.put_embed(:external_wiki, external_wiki)
    |> Ecto.Changeset.put_embed(:internal_tracker, internal_tracker)
    |> Ecto.Changeset.put_embed(:owner, owner)
    |> Ecto.Changeset.put_embed(:permissions, permissions)
    |> Ecto.Changeset.apply_changes()
  end

  @impl Giteax.Module
  def parse_list(nil), do: []
  def parse_list([]), do: []

  def parse_list(list) do
    for params <- list do
      external_tracker = ExternalTracker.parse(params["external_tracker"])
      external_wiki = ExternalWiki.parse(params["external_wiki"])
      internal_tracker = InternalTracker.parse(params["internal_tracker"])
      owner = User.parse(params["owner"])
      permissions = Permission.parse(params["permissions"])

      %__MODULE__{}
      |> Ecto.Changeset.cast(params, @fields)
      |> Ecto.Changeset.put_embed(:external_tracker, external_tracker)
      |> Ecto.Changeset.put_embed(:external_wiki, external_wiki)
      |> Ecto.Changeset.put_embed(:internal_tracker, internal_tracker)
      |> Ecto.Changeset.put_embed(:owner, owner)
      |> Ecto.Changeset.put_embed(:permissions, permissions)
      |> Ecto.Changeset.apply_changes()
    end
  end
end
