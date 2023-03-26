defmodule Giteax.Admin.Schemas.User do
  @moduledoc """
  User struct.
  """

  use Ecto.Schema

  @behaviour Giteax.Module
  @fields ~w(active avatar_url created description email followers_count following_count full_name id is_admin language last_login location login prohibit_login restricted starred_repos_count visibility website)a
  @derive Jason.Encoder
  @primary_key false

  @type t() :: %__MODULE__{
          active: boolean(),
          avatar_url: String.t(),
          created: DateTime.t(),
          description: String.t(),
          email: String.t(),
          followers_count: integer(),
          following_count: integer(),
          full_name: String.t(),
          id: integer(),
          is_admin: boolean(),
          language: String.t(),
          last_login: DateTime.t(),
          location: String.t(),
          login: String.t(),
          prohibit_login: boolean(),
          restricted: boolean(),
          starred_repos_count: integer(),
          visibility: String.t(),
          website: String.t()
        }

  embedded_schema do
    field(:active, :boolean)
    field(:avatar_url, :string)
    field(:created, :utc_datetime_usec)
    field(:description, :string)
    field(:email, :string)
    field(:followers_count, :integer)
    field(:following_count, :integer)
    field(:full_name, :string)
    field(:id, :integer)
    field(:is_admin, :boolean)
    field(:language, :string)
    field(:last_login, :utc_datetime_usec)
    field(:location, :string)
    field(:login, :string)
    field(:prohibit_login, :boolean)
    field(:restricted, :boolean)
    field(:starred_repos_count, :integer)
    field(:visibility, :string)
    field(:website, :string)
  end

  @impl Giteax.Module
  def parse(nil), do: nil

  def parse(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @fields)
    |> Ecto.Changeset.apply_changes()
  end

  @impl Giteax.Module
  def parse_list(nil), do: []
  def parse_list([]), do: []

  def parse_list(list) do
    for params <- list do
      %__MODULE__{}
      |> Ecto.Changeset.cast(params, @fields)
      |> Ecto.Changeset.apply_changes()
    end
  end
end
