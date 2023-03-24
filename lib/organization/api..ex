defmodule Giteax.Organization.Api do
  @moduledoc """
  Organization API for Gitea
  """

  alias Giteax.Organization.Schemas.RepoRequestParams
  alias Giteax.Organization.Schemas.OrgRequestParams
  alias Giteax.Organization.Schemas.TeamRequestParams
  alias Giteax.Organization.Schemas.TeamListRequestParams
  alias Giteax.PathParams
  alias Giteax.Response

  @doc """
  Create an organization.

  ## Required Body
    * `:username` - Username of the organization to create.

  ## Body
  * `:description`
  * `:full_name`
  * `:location`
  * `:repo_admin_change_team_access` - Avaliable to change org team members.
  * `:visibility` - `default: :public`.
  * `:website` - Website of the organization to create.

  ### Body Details
  * visibility: can be one of
    `~w(public limited private)a`
  * website: validated by regex
    ~r/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/

  ## Examples

      iex> create_org(%Tesla.Client{}, %{username: "username"})
      {:ok, body}

      iex> create_org(%Tesla.Client{}, %{username: "already_inserted_username"})
      {:error, errors}
  """
  @spec create_org(Tesla.Client.t(), %{required(:username) => String.t()}) ::
          {:ok, any()} | {:error, any()}
  def create_org(%Tesla.Client{} = client, body) when map_size(body) > 0 do
    with {:ok, %OrgRequestParams{} = struct} <- OrgRequestParams.validate(body) do
      client
      |> Tesla.post("/orgs", struct)
      |> Response.handle()
    end
  end

  def create_org(%Tesla.Client{}, _body),
    do: {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

  def create_org(_client, _body),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete an organization.

  ## Required Params
    * `:org` - Username of the organization to create.

  ## Examples

      iex> delete_org(%Tesla.Client{}, org: "org")
      {:ok, body}

      iex> delete_org(%Tesla.Client{}, org: "deleted_org")
      {:error, errors}
  """
  @spec delete_org(Tesla.Client.t(), org: String.t()) :: {:ok, any()} | {:error, any()}
  def delete_org(%Tesla.Client{} = client, params) when is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      client
      |> Tesla.delete("/orgs/:org", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def delete_org(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def delete_org(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Create an organization.

  ## Required Params
  * `:org` - the organization's name.

  ## Required Body
  * `:name` - Name of the repository to create.

  ## Body
  * `:auto_init` - Whether the repository should be auto-intialized?
  * `:default_branch` - DefaultBranch of the repository (used when initializes and in template)
  * `:description` - Description of the repository to create
  * `:gitignores` - Gitignores to use
  * `:issue_labels` - Label-Set to use
  * `:license` - License to use
  * `:private` - Whether the repository is private
  * `:readme` - Readme of the repository to create
  * `:template` - Whether the repository is template
  * `:trust_model` - TrustModel of the repository

  ## Examples

      iex> create_org_repo(%Tesla.Client{}, %{name: "name"}, [org: "org"])
      {:ok, body}

      iex> create_org_repo(%Tesla.Client{}, %{name: "bad_name"}, [org: "bad_org"])
      {:error, errors}
  """
  @spec create_org_repo(Tesla.Client.t(), %{required(:name) => String.t()}, org: String.t()) ::
          {:ok, any()} | {:error, any()}
  def create_org_repo(%Tesla.Client{} = client, body, params)
      when map_size(body) > 0 and is_list(params) do
    with {:ok, %RepoRequestParams{} = struct} <- RepoRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      client
      |> Tesla.post("/orgs/:org/repos", struct, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def create_org_repo(%Tesla.Client{}, body, _params) when map_size(body) > 0,
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def create_org_repo(%Tesla.Client{}, _body, _params),
    do: {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

  def create_org_repo(_client, _body, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  List all organization teams.

  ## Required Params
  * `:org` - the organization's name.

  ## Body
  * `:page_number` - page number of results to return, default: `1`
  * `:limit` - page size of results, default: `50`

  ## Examples

      iex> list_org_team(%Tesla.Client{}, %{page_number: 1, limit: 1}, [org: "org"])
      {:ok, body}

      iex> list_org_team(%Tesla.Client{}, %{page_number: 1, limit: 1}, [org: "bad_org"])
      {:error, errors}
  """
  @spec list_org_team(
          Tesla.Client.t(),
          %{required(:page_number) => number(), required(:limit) => number()},
          org: String.t()
        ) :: {:ok, any()} | {:error, any()}
  def list_org_team(%Tesla.Client{} = client, body, params)
      when is_map(body) and is_list(params) do
    with {:ok, %TeamListRequestParams{} = struct} <- TeamListRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      query = TeamListRequestParams.to_list(struct)

      client
      |> Tesla.get("/orgs/:org/teams", query: query, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def list_org_team(%Tesla.Client{}, body, _params) when is_map(body),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def list_org_team(%Tesla.Client{}, _body, _params),
    do: {:error, %{field: :body, errors: ["expected to be a map"]}}

  def list_org_team(_client, _body, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Create a team member.

  ## Required Params
  * `:id` - the team id.
  * `:username` - the team member's name.

  ## Examples

      iex> add_team_member(%Tesla.Client{}, [id: 1, username: "username"])
      {:ok, body}

      iex> add_team_member(%Tesla.Client{}, [id: 2, username: "bad_username"])
      {:error, errors}
  """
  @spec add_team_member(Tesla.Client.t(), id: number(), username: String.t()) ::
          {:ok, any()} | {:error, any()}
  def add_team_member(%Tesla.Client{} = client, params) when is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:id, :username]) do
      client
      |> Tesla.put("/teams/:id/members/:username", nil, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def add_team_member(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def add_team_member(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete a team member.

  ## Required Params
  * `:id` - the team id.
  * `:username` - the team member's name.

  ## Examples

      iex> delete_team_member(%Tesla.Client{}, [id: 1, username: "username"])
      {:ok, body}

      iex> delete_team_member(%Tesla.Client{}, [id: 2, username: "bad_username"])
      {:error, errors}
  """
  @spec delete_team_member(Tesla.Client.t(), id: number(), username: String.t()) ::
          {:ok, any()} | {:error, any()}
  def delete_team_member(%Tesla.Client{} = client, params) when is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:id, :username]) do
      client
      |> Tesla.delete("/teams/:id/members/:username", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def delete_team_member(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def delete_team_member(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Create an team.

  ## Required Params
  * `:org` - the organization's name.

  ## Required Body
    * `:name` - Username of the team to create.

  ## Body
  * `:can_create_org_repo` - Ability to create organization repo.
  * `:description` - Description of the team to create.
  * `:includes_all_repositories` - Ability to have all repos.
  * `:permission` - Permissions.
  * `:units` - Units.

  ### Body Details
  * permission: can be one of
    `~w(read write admin)a`
  * units: list of
    `~w(repo.code repo.issues repo.ext_issues repo.wiki repo.pulls repo.releases repo.projects repo.ext_wiki)a`

  ## Examples

      iex> create_team(%Tesla.Client{}, %{name: "name"}, [org: "org"])
      {:ok, body}

      iex> create_team(%Tesla.Client{}, %{name: "already_inserted_name"}, [org: "bad_org"])
      {:error, errors}
  """
  @spec create_team(Tesla.Client.t(), %{required(:name) => String.t()}, org: String.t()) ::
          {:ok, any()} | {:error, any()}
  def create_team(%Tesla.Client{} = client, body, params)
      when map_size(body) > 0 and is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:org]),
         {:ok, %TeamRequestParams{} = struct} <- TeamRequestParams.validate(body) do
      client
      |> Tesla.post("/orgs/:org/teams", struct, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def create_team(%Tesla.Client{}, body, _params) when map_size(body) > 0,
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def create_team(%Tesla.Client{}, _body, _params),
    do: {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

  def create_team(_client, _body, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete a team.

  ## Required Params
  * `:id` - the team id.

  ## Examples

      iex> delete_team(%Tesla.Client{}, [id: 1])
      {:ok, body}

      iex> delete_team(%Tesla.Client{}, [id: -1])
      {:error, errors}
  """
  @spec delete_team(Tesla.Client.t(), id: number()) ::
          {:ok, any()} | {:error, any()}
  def delete_team(%Tesla.Client{} = client, params) when is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:id]) do
      client
      |> Tesla.delete("/teams/:id", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def delete_team(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def delete_team(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}
end
