defmodule Giteax.Organization.Structs.RepoRequestParams do
  @moduledoc """
  Gitea: Struct for repo ogranization creation
  """
  @derive Jason.Encoder
  @enforce_keys ~w(name)a

  @type t() :: %__MODULE__{
          name: String.t(),
          auto_init: boolean(),
          default_branch: String.t(),
          description: String.t(),
          private: boolean()
        }

  defstruct name: nil, auto_init: false, default_branch: "main", description: "", private: true

  @spec new(map()) :: t()
  def new(params), do: struct!(__MODULE__, params)
end
