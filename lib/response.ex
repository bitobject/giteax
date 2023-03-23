defmodule Giteax.Response do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @spec handle(Tesla.Env.result()) :: {:ok, any()} | {:error, any()}
  def handle({:ok, %Tesla.Env{status: status, body: resp_body}}) when status in 200..299,
    do: {:ok, resp_body}

  def handle({:ok, %Tesla.Env{body: resp_body}}), do: {:error, resp_body}
  def handle({:error, error}), do: {:error, error}
  def handle(error), do: {:error, error}
end
