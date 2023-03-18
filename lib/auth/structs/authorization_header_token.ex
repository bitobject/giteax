defmodule Giteax.Structs.AuthorizationHeaderToken do
  @moduledoc """
  Authorization Header Token struct
  """

  @type t :: %__MODULE__{token: String.t()}
  @enforce_keys [:token]

  defstruct [:token]
end
