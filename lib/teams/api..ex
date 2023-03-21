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
  def add_team_member(client, params) do
    case PathParams.validate(params, [:id, :username]) do
      {:ok, validated_params} ->
        client
        |> Tesla.put("/teams/:id/members/:username", opts: [path_params: validated_params])
        |> Response.handle()

      {:error, errors} ->
        {:error, errors}
    end
  end
end
