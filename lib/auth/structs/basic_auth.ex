defmodule Giteax.Structs.BasicAuth do
  @moduledoc """
  Basic Auth struct
  """

  @type t :: %__MODULE__{username: String.t(), password: String.t()}
  @enforce_keys [:username, :password]

  defstruct [:username, :password]
end
