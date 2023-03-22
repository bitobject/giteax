defmodule Giteax.Teams.Api do
  @moduledoc """
  Teams API for Gitea
  """

  alias Giteax.PathParams
  alias Giteax.Response

  @doc """
  Create an team member.

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
      |> Tesla.put("/teams/:id/members/:username", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def add_team_member(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def add_team_member(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete an team member.

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
end
