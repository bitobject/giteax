defmodule Giteax.Admin.Api do
  @moduledoc """
  User API for Gitea
  """

  alias Giteax.Admin.Schemas.UserRequestParams
  alias Giteax.Response

  @doc """
  Create a user.

  ## Required Body
  * `:email`
  * `:password`
  * `:username`

  ## Body
  * `:full_name`
  * `:login_name`
  * `:must_change_password`
  * `:send_notify`
  * `:source_id`
  * `:visibility`

  ## Examples

      iex> create_user_by_admin(%Tesla.Client{}, %{email: "email", password: "password", username: "username"})
      {:ok, %Tesla.Env{}}

      iex> create_user_by_admin(%Tesla.Client{}, %{email: "invalid_email", password: "invalid_password", username: "invalid_username"})
      {:error, errors}
  """
  @spec create_user_by_admin(Tesla.Client.t(), %{
          required(:email) => String.t(),
          required(:password) => String.t(),
          required(:username) => String.t()
        }) :: {:ok, any()} | {:error, any()}
  def create_user_by_admin(client, body) do
    case UserRequestParams.validate(body) do
      {:ok, %UserRequestParams{} = struct} ->
        client
        |> Tesla.post("/admin/users", struct)
        |> Response.handle()

      {:error, errors} ->
        {:error, errors}
    end
  end
end
