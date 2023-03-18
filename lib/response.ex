defmodule Giteax.Response do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @spec handle(Tesla.Env.result()) :: {:ok, any()} | {:error, any()}
  def handle(resp) do
    case resp do
      {:ok, %Tesla.Env{status: status, body: resp_body}} when status < 400 ->
        {:ok, resp_body}

      {:ok, %Tesla.Env{body: resp_body}} ->
        {:error, resp_body}

      {:error, error} ->
        {:error, error}
    end
  end
end
