defmodule Giteax.Repository.Api do
  @moduledoc """
  Repository API for Gitea
  """

  alias Giteax.Helper

  @doc """
  Delete a repository.

  Returns `Tesla.Env.result()`.

  ## Required Options
  * `:owner` - the owner's name. If owner is organazation - organization's name.
  * `:repo` - the name of the repository.

  ## Examples

      iex> delete_repo(%Tesla.Client{}, [repo: "repo", owner: "owner"])
      {:ok, %Tesla.Env{}}

      iex> delete_repo(%Tesla.Client{}, [repo: "repo", owner: "owner"])
      {:error, error}
  """
  @spec delete_repo(Tesla.Client.t(), Keyword.t()) :: Tesla.Env.result()
  def delete_repo(client, params) do
    validated_params = Helper.validate_params(params, [:owner, :repo])
    Tesla.delete(client, "/repos/:owner/:repo", opts: [path_params: validated_params])
  end
end
