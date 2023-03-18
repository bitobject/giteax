defmodule Giteax.Structs.AccessToken do
  @moduledoc """
  Access Token struct
  """

  @type t :: %__MODULE__{token: String.t()}
  @enforce_keys [:token]

  defstruct [:token]
end
