defmodule Giteax.Organization.Api do
  @moduledoc """
  Organization API for Gitea
  """

  alias Giteax.Organization.Schemas.RepoRequestParams
  alias Giteax.Organization.Schemas.OrgRequestParams
  alias Giteax.Organization.Schemas.TeamListRequestParams
  alias Giteax.PathParams
  alias Giteax.Response

  # TODO add guards to for incomming tesla client, body and params and make new tests

  @doc """
  Create an organization.

  ## Required Body
    * `:username` - Username of the organization to create.

  ## Body
  * `:description` - Description of the organization to create.
  * `:full_name` - Full name of the organization to create.
  * `:location` - Location of the organization to create.
  * `:repo_admin_change_team_access` - Avaliable to change org team members.
  * `:visibility` - Visibility of the organization to create.
  * `:website` - Website of the organization to create.

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

  def create_org(%Tesla.Client{}, %{} = _body),
    do: {:error, %{field: :body, errors: ["expected to be a not empty map"]}}

  def create_org(%Tesla.Client{}, _body),
    do: {:error, %{field: :body, errors: ["expected to be a map"]}}

  def create_org(_client, _body),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete an organization.

  ## Required Body
    * `:org` - Username of the organization to create.

  ## Examples

      iex> delete_org(%Tesla.Client{}, org: "org")
      {:ok, org: body}

      iex> delete_org(%Tesla.Client{}, org: "deleted_org")
      {:error, errors}
  """
  @spec delete_org(Tesla.Client.t(), org: String.t()) :: {:ok, any()} | {:error, any()}
  def delete_org(client, params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      client
      |> Tesla.delete("/orgs/:org", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

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

      iex> create_org_repo(%Tesla.Client{}, body, [org: "org"])
      {:ok, body}

      iex> create_org_repo(%Tesla.Client{}, body, [org: "bad_org"])
      {:error, errors}
  """
  @spec create_org_repo(Tesla.Client.t(), %{required(:name) => String.t()}, org: String.t()) ::
          {:ok, any()} | {:error, any()}
  def create_org_repo(client, body, params) do
    with {:ok, %RepoRequestParams{} = struct} <- RepoRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      client
      |> Tesla.post("/orgs/:org/repos", struct, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  @doc """
  List all organization teams.

  ## Required Params
  * `:org` - the organization's name.

  ## Body
  * `:page_number` - page number of results to return.
  * `:limit` - page size of results.


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
  def list_org_team(client, body, params) do
    with {:ok, %TeamListRequestParams{} = struct} <- TeamListRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      filters =
        struct
        |> TeamListRequestParams.from_struct()
        |> URI.encode_query()

      client
      |> Tesla.get("/orgs/:org/teams" <> "?" <> filters, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end
end
