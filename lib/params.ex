defmodule Giteax.PathParams do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @keyword_error_msg "expected to be a keyword list"
  @inclusion_error_msg "expected to be in params"

  @spec validate(Keyword.t(), list(atom())) ::
          {:ok, Keyword.t()} | {:error, %{field: atom(), errors: list(String.t())}}
  def validate([], _required), do: {:error, %{field: :params, errors: [@keyword_error_msg]}}

  def validate(params, required) do
    if Keyword.keyword?(params) do
      fetched_params = Keyword.take(params, required)
      validate_fetched_params(required, fetched_params)
    else
      {:error, %{field: :params, errors: [@keyword_error_msg]}}
    end
  end

  @spec validate_fetched_params(list(atom()), Keyword.t()) ::
          {:ok, Keyword.t()} | {:error, %{field: atom(), errors: list(String.t())}}
  defp validate_fetched_params([], params), do: {:ok, params}

  defp validate_fetched_params([hd | tail], params) do
    if Keyword.has_key?(params, hd) do
      validate_fetched_params(tail, params)
    else
      {:error, %{field: hd, errors: [@inclusion_error_msg]}}
    end
  end
end
