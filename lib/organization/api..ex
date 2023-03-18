defmodule Giteax.Organization.Api do
  @moduledoc """
  Organization API for Gitea
  """

  alias Giteax.Organization.Schemas.RepoRequestParams
  alias Giteax.Organization.Schemas.TeamListRequestParams
  alias Giteax.PathParams
  alias Giteax.Response

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

      iex> create_org_repo(%Tesla.Client{}, body)
      {:ok, body}

      iex> create_org_repo(%Tesla.Client{}, body)
      {:error, errors}
  """
  @spec create_org_repo(Tesla.Client.t(), map()) :: {:ok, any()} | {:error, any()}
  def create_org_repo(client, body) do
    with {:ok, %RepoRequestParams{} = struct} <- RepoRequestParams.validate(body) do
      client
      |> Tesla.post("/orgs", struct)
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
  @spec create_org_repo(Tesla.Client.t(), map(), Keyword.t()) :: {:ok, any()} | {:error, any()}
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
  @spec list_org_team(Tesla.Client.t(), map(), Keyword.t()) :: {:ok, any()} | {:error, any()}
  def list_org_team(client, body, params) do
    with {:ok, %TeamListRequestParams{} = struct} <- TeamListRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      filters = URI.encode_query(struct)

      client
      |> Tesla.get("/orgs/:org/teams" <> "?" <> filters, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end
end
