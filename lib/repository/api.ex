defmodule Giteax.Repository.Api do
  @moduledoc """
  Repository API for Gitea
  """

  alias Giteax.PathParams
  alias Giteax.Response

  @doc """
  Delete a repository.

  ## Required Params
  * `:owner` - the owner's name. If owner is organazation - organization's name.
  * `:repo` - the name of the repository.

  ## Examples

      iex> delete_repo(%Tesla.Client{}, [repo: "repo", owner: "owner"])
      {:ok, %Tesla.Env{}}

      iex> delete_repo(%Tesla.Client{}, [repo: "repo", owner: "owner"])
      {:error, error}
  """
  @spec delete_repo(Tesla.Client.t(), owner: String.t(), repo: String.t()) :: Tesla.Env.result()
  def delete_repo(%Tesla.Client{} = client, params) when is_list(params) do
    case PathParams.validate(params, [:owner, :repo]) do
      {:ok, validated_params} ->
        client
        |> Tesla.delete("/repos/:owner/:repo", opts: [path_params: validated_params])
        |> Response.handle()

      {:error, error} ->
        {:error, error}
    end
  end

  def delete_repo(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def delete_repo(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}
end
