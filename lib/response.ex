defmodule Giteax.Response do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @spec handle(Tesla.Env.result()) :: {:ok, any()} | {:error, any()}
  def handle(resp), do: handle(resp, &default_function/1)

  @spec handle(Tesla.Env.result(), function()) :: {:ok, any()} | {:error, any()}
  def handle({:ok, %Tesla.Env{status: status, body: resp_body}}, function)
      when status in 200..299,
      do: {:ok, function.(resp_body)}

  def handle({:ok, %Tesla.Env{body: resp_body}}, _function), do: {:error, resp_body}
  def handle({:error, error}, _function), do: {:error, error}
  def handle(error, _function), do: {:error, error}

  defp default_function(term), do: term
end
