# defmodule AssistantsBuilderService.Git.Api do
#   @moduledoc """
#   Методы для работы с API GIT
#   """

#   alias AssistantsBuilderService.Git.Client, as: GitClient
#   alias AssistantsBuilderService.Git.RepoRequestParams
#   alias AssistantsBuilderService.Git.ResponseHandler
#   alias AssistantsBuilderService.ResponseError

#   @spec create_org_repo(String.t(), map()) :: {:ok, any()} | {:error, list(ResponseError.t())}
#   def create_org_repo(company, params) when is_binary(company) and map_size(params) > 0 do
#     body = RepoRequestParams.new(params)

#     GitClient.admin_client()
#     |> GitClient.create_org_repo(company, body)
#     |> ResponseHandler.handle_response()
#   end

#   def create_org_repo(company, _params) when is_binary(company),
#     do: {:error, [ResponseError.create("params", ["Expected to be a map"])]}

#   def create_org_repo(_company, _params),
#     do: {:error, [ResponseError.create("company", ["Expected to be a string"])]}

#   @spec delete_org_repo(String.t(), String.t()) ::
#           {:ok, any()} | {:error, list(ResponseError.t())}
#   def delete_org_repo(company, repo) when is_binary(company) and is_binary(repo) do
#     GitClient.admin_client()
#     |> GitClient.delete_org_repo(company, repo)
#     |> ResponseHandler.handle_response()
#   end

#   def delete_org_repo(company, _repo) when is_binary(company),
#     do: {:error, [ResponseError.create("repo", ["Expected to be a string"])]}

#   def delete_org_repo(_company, _repo),
#     do: {:error, [ResponseError.create("company", ["Expected to be a string"])]}
# end
