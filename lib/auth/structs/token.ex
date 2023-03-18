defmodule Giteax.Structs.Token do
  @moduledoc """
  Token struct
  """

  @type t :: %__MODULE__{token: String.t()}
  @enforce_keys [:token]

  defstruct [:token]
end
