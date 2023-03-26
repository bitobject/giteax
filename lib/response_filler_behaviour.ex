defmodule Giteax.ReponseFiller do
  @moduledoc """
  Behaviour for parsing incomming data from Gitea.
  """
  @callback process(map() | nil) :: struct() | nil
  @callback process_list(list()) :: list()
end
