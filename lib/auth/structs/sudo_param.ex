defmodule Giteax.Structs.SudoParam do
  @moduledoc """
  Sudo Param struct
  """

  @type t :: %__MODULE__{token: String.t()}
  @enforce_keys [:token]

  defstruct [:token]
end
