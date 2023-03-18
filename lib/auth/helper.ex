defmodule Giteax.Auth.Helper do
  @moduledoc """
  Helper functions for Gitea Auth.
  """

  @spec update(list(), atom(), tuple(), boolean(), list()) :: list()
  def update(list, target, authorization, flag \\ false, acc \\ [])
  def update([], target, authorization, false, acc), do: [{target, [authorization]} | acc]
  def update([], _target, _authorization, true, acc), do: acc

  def update([{k, v} | tail], target, authorization, _flag, acc) when k == target,
    do: update(tail, target, authorization, true, [{k, [authorization | v]} | acc])

  def update([hd | tail], target, authorization, _flag, acc) when hd == target,
    do: update(tail, target, authorization, true, [{hd, [authorization]} | acc])

  def update([hd | tail], target, authorization, flag, acc),
    do: update(tail, target, authorization, flag, [hd | acc])
end
