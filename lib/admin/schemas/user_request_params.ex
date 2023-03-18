defmodule Giteax.Admin.Schemas.UserRequestParams do
  @moduledoc """
  Gitea: request schema for user creation
  """
  use Ecto.Schema

  @fields ~w(email full_name login_name must_change_password password send_notify source_id username visibility)a
  @required_fields ~w(email password username)a
  @derive {Jason.Encoder, only: @fields}
  @primary_key false

  @type t() :: %__MODULE__{
          email: String.t(),
          full_name: String.t(),
          login_name: String.t(),
          must_change_password: boolean(),
          password: String.t(),
          send_notify: boolean(),
          source_id: integer(),
          username: String.t(),
          visibility: String.t()
        }

  schema "repo_request_params" do
    field(:email, :string)
    field(:full_name, :string)
    field(:login_name, :string)
    field(:must_change_password, :boolean, default: false)
    field(:password, :string)
    field(:send_notify, :boolean, default: false)
    field(:source_id, :integer)
    field(:username, :string)
    field(:visibility, :string)
  end

  @spec validate(map()) :: {:ok, t()} | {:error, Keyword.t()}
  def validate(params) do
    case change(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}

      %Ecto.Changeset{errors: errors} ->
        {:error, errors}
    end
  end

  @spec apply(Ecto.Changeset.t()) :: t()
  def apply(changeset) do
    Ecto.Changeset.apply_changes(changeset)
  end

  @spec change(map()) :: Ecto.Changeset.t()
  defp change(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end
