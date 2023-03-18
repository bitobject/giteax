defmodule Giteax.Structs.SudoHeader do
  @moduledoc """
  Sudo Header struct
  """

  @type t :: %__MODULE__{token: String.t()}
  @enforce_keys [:token]

  defstruct [:token]
end
