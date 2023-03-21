defmodule Giteax do
  @moduledoc """
  Documentation for `Giteax`.
  """

  @spec hello(list(), map()) :: {:ok, any} | {:error, any}
  def hello(middlewares, params) do
    # auth = Keyword.fetch!(params, :auth)

    # auth = %Giteax.Structs.AuthorizationHeaderToken{token: "4c3b11a8efd39fabad48950e9deb565d3e1dc182"}
    middlewares =
      [
        {Tesla.Middleware.BaseUrl, "https://rnd-cloud2.cti.ru/gitea/api/v1"},
        Tesla.Middleware.FollowRedirects,
        {Tesla.Middleware.Headers,
         [{"Authorization", "token 4c3b11a8efd39fabad48950e9deb565d3e1dc182"}]},
        Tesla.Middleware.PathParams,
        Tesla.Middleware.JSON,
        {Tesla.Middleware.Retry, [delay: 500, max_retries: 1]}
      ]

      # auth
      # |> Giteax.Auth.add(middlewares)
      |> Tesla.client()
      |> Giteax.Organization.Api.create_org_repo(%{name: "davidsssr"}, org: "cti")

    "3c61150b8a52b93a196b641e19addda2155825dc"
    "superuser"
    "superuser"
    # |> Tesla.post("/orgs/:org/repos", %{name: "davidss"}, opts: [path_params: [org: "cti"]])
  end
end
