defmodule Giteax.Helper do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @spec validate_params(Keyword.t(), list(atom())) ::
          {:ok, Keyword.t()} | {:error, %{field: atom(), errors: list(String.t())}}
  def validate_params(params, required) do
    fetched_params = Keyword.take(params, required)

    validate_fetched_params(required, fetched_params)
  end

  @spec validate_fetched_params(list(atom()), Keyword.t()) ::
          {:ok, Keyword.t()} | {:error, %{field: atom(), errors: list(String.t())}}
  defp validate_fetched_params([], params), do: {:ok, params}

  defp validate_fetched_params([hd | tail], params) do
    if Keyword.has_key?(params, hd) do
      validate_fetched_params(tail, params)
    else
      {:error, %{field: hd, errors: ["expected to be in params"]}}
    end
  end
end
