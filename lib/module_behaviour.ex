defmodule Giteax.Module do
  @moduledoc """
  Behaviour for parsing incomming data from Gitea.
  """
  @callback parse(map() | nil) :: struct() | nil
  @callback parse_list(list()) :: list()
end
