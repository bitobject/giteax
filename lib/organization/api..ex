defmodule Giteax.Organization.Api do
  @moduledoc """
  Organization API for Gitea
  """

  alias Giteax.Organization.Schemas.OrgRequestParams
  alias Giteax.PathParams
  alias Giteax.Response

  @doc """
  Create a repository.

  Returns `Tesla.Env.result()`.

  ## Required Options
  * `:org` - the organization's name.

  ## Examples

      iex> create_org_repo(%Tesla.Client{}, %{username: "name"}, [org: "org"])
      {:ok, %Tesla.Env{}}

      iex> create_org_repo(%Tesla.Client{}, %{username: "existed_name"}, [org: "bad_org"])
      {:error, errors}
  """
  @spec create_org_repo(Tesla.Client.t(), map(), Keyword.t()) :: {:ok, any()} | {:error, any()}
  def create_org_repo(client, body, params) do
    with {:ok, %OrgRequestParams{} = struct} <- OrgRequestParams.validate(body),
         {:ok, validated_params} <- PathParams.validate(params, [:org]) do
      client
      |> Tesla.post("/orgs/:org/repos", struct, opts: [path_params: validated_params])
      |> Response.handle()
    end
  end
end
