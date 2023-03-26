defmodule Giteax.Admin.Api do
  @moduledoc """
  User API for Gitea
  """

  alias Giteax.Admin.RequestStructs.UserParams
  alias Giteax.Admin.Schemas.User
  alias Giteax.PathParams
  alias Giteax.Response

  @doc """
  Create a user.

  ## Required Body
  * `:email`
  * `:password`
  * `:username`

  ### Body Details
  * email: validated by regex
    `~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i`

  ## Body
  * `:full_name`
  * `:login_name`
  * `:must_change_password`
  * `:send_notify`
  * `:source_id`
  * `:visibility`

  ## Examples

      iex> create_user_by_admin(%Tesla.Client{}, %{email: "email", password: "password", username: "username"})
      {:ok, %Giteax.Admin.Schemas.User{}}

      iex> create_user_by_admin(%Tesla.Client{}, %{email: "invalid_email", password: "invalid_password", username: "invalid_username"})
      {:error, errors}
  """
  @spec create_user_by_admin(Tesla.Client.t(), %{
          required(:email) => String.t(),
          required(:password) => String.t(),
          required(:username) => String.t()
        }) :: {:ok, User.t() | any()} | {:error, any()}
  def create_user_by_admin(%Tesla.Client{} = client, body) when map_size(body) > 2 do
    with {:ok, %UserParams{} = struct} <- UserParams.validate(body) do
      client
      |> Tesla.post("/admin/users", struct)
      |> Response.handle(&User.parse/1)
    end
  end

  def create_user_by_admin(%Tesla.Client{}, _body),
    do: {:error, %{field: :params, errors: ["expected to be a non empty map"]}}

  def create_user_by_admin(_client, _body),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

  @doc """
  Delete a user.

  ## Required Params
  * `:username`

  ## Examples

      iex> delete_user_by_admin(%Tesla.Client{}, [username: "username"])
      {:ok, body}

      iex> delete_user_by_admin(%Tesla.Client{}, [username: "invalid_username"])
      {:error, errors}
  """
  @spec delete_user_by_admin(Tesla.Client.t(), username: String.t()) ::
          {:ok, any()} | {:error, any()}
  def delete_user_by_admin(%Tesla.Client{} = client, params) when is_list(params) do
    with {:ok, validated_params} <- PathParams.validate(params, [:username]) do
      client
      |> Tesla.delete("/admin/users/:username", opts: [path_params: validated_params])
      |> Response.handle()
    end
  end

  def delete_user_by_admin(%Tesla.Client{}, _params),
    do: {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

  def delete_user_by_admin(_client, _params),
    do: {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}
end
