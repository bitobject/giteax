# defmodule AssistantsBuilderService.Git.Client do
#   @moduledoc """
#   Клиент для работы с API GIT
#   """
#   use Tesla, only: ~w(post delete)a

#   alias AssistantsBuilderService.Git.RepoRequestParams

#   adapter(Tesla.Adapter.Hackney)

#   @spec create_org_repo(Tesla.Client.t(), String.t(), RepoRequestParams.t()) :: Tesla.Env.result()
#   def create_org_repo(client, org, body) do
#     params = [org: org]

#     post(client, "/orgs/:org/repos", body, opts: [path_params: params])
#   end

#   @spec delete_org_repo(Tesla.Client.t(), String.t(), String.t()) :: Tesla.Env.result()
#   def delete_org_repo(client, owner, repo) do
#     params = [owner: owner, repo: repo]

#     delete(client, "/repos/:owner/:repo", opts: [path_params: params])
#   end

#   @spec client :: Tesla.Client.t()
#   def client(opts) do
#     middleware =
#       [
#         {Tesla.Middleware.BasicAuth, username: opts[:username], password: opts[:password]}
#       ] ++ @middleware

#     middleware = [
#       {Tesla.Middleware.BaseUrl, AssistantsBuilderService.git_url()},
#       {Tesla.Middleware.Headers,
#        [{"Authorization", "token " <> AssistantsBuilderService.git_admin_token()}]},
#       Tesla.Middleware.PathParams,
#       Tesla.Middleware.FollowRedirects,
#       Tesla.Middleware.JSON,
#       {Tesla.Middleware.Retry, AssistantsBuilderService.git_request_retry_params()}
#     ]

#     Tesla.client(middleware)
#   end
# end
