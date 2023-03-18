# defmodule AssistantsBuilderService.Git.ResponseHandler do
#   @moduledoc """
#   Модуль для рбработки запросов с API GIT
#   """

#   alias AssistantsBuilderService.ResponseError

#   @spec handle_response(Tesla.Env.result(), function()) ::
#           {:ok, any()} | {:error, list(ResponseError.t())}
#   def handle_response(resp, fun \\ &basic_handle/1)
#   def handle_response(resp, fun), do: fun.(resp)

#   @spec basic_handle(Tesla.Env.result()) :: {:ok, any()} | {:error, list(ResponseError.t())}
#   defp basic_handle(resp) do
#     case resp do
#       {:ok, %Tesla.Env{status: status, body: resp_body}} when status < 400 ->
#         {:ok, resp_body}

#       {:ok, %Tesla.Env{status: status, body: resp_body}} ->
#         {:error,
#          [
#            ResponseError.create("response", [
#              "status:\s" <>
#                AssistantsBuilderService.term_to_string(status) <>
#                "\nbody:\s" <>
#                AssistantsBuilderService.term_to_string(resp_body)
#            ])
#          ]}

#       {:error, error} ->
#         {:error,
#          [ResponseError.create("unknown_error", [AssistantsBuilderService.term_to_string(error)])]}
#     end
#   end
# end
