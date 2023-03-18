defmodule Giteax.Organization.Api do
  @moduledoc """
  Organization API for Gitea
  """

  alias Giteax.Organization.Structs.RepoRequestParams
  alias Giteax.Helper

  @doc """
  Create a repository.

  Returns `Tesla.Env.result()`.

  ## Required Options
  * `:org` - the organization's name.

  ## Examples

      iex> create_org_repo(%Tesla.Client{}, %RepoRequestParams{}, [org: "org"])
      {:ok, %Tesla.Env{}}

      iex> create_org_repo(%Tesla.Client{}, %RepoRequestParams{}, [org: "bad_org"])
      {:error, error}
  """
  @spec create_org_repo(Tesla.Client.t(), RepoRequestParams.t(), Keyword.t()) ::
          Tesla.Env.result()
  def create_org_repo(client, %RepoRequestParams{} = body, params) do
    case Helper.validate_params(params, [:org]) do
      {:ok, validated_params} ->
        Tesla.post(client, "/orgs/:org/repos", body, opts: [path_params: validated_params])
      {:error, error} ->
        {:error, error}
    end
  end
end
