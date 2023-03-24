defmodule Giteax.Repository.ApiTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  @api_path "/api/v1"
  @params_data_types [0, -1, 0.0, -1.0, "some", "", %{some: :data}, %{"some" => "data"}, [], %{}]

  describe "Delete repository api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, _body} = Giteax.Organization.Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Giteax.Organization.Api.delete_org(test_client(), org: org_params.username)
      end)

      %{org: org_params.username}
    end

    test "delete_repo/3: success", %{org: org} do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org_repo(test_client(), %{name: "repo_2"}, org: org)

      assert {:ok, _body} =
               Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_2", owner: org)
    end

    test "delete_repo/3: already deleted organization", %{org: org} do
      assert {:error, _error} =
               Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_2", owner: org)
    end

    test "delete_repo/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Giteax.Repository.Api.delete_repo(test_client(), data),
               "data: #{inspect(data)}"
      end
    end

    test "delete_repo/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @params_data_types do
        assert error == Giteax.Repository.Api.delete_repo(data, repo: "repo_2", owner: org),
               "data: #{inspect(data)}"
      end
    end
  end

  defp test_client do
    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    middleware = [
      {Tesla.Middleware.BaseUrl, url() <> @api_path},
      {Tesla.Middleware.Headers, [{"Authorization", "token " <> token()}]},
      Tesla.Middleware.FollowRedirects,
      Tesla.Middleware.PathParams,
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware, adapter)
  end

  # TODO make this frouth config for docker env for test
  defp token, do: Application.get_env(:giteax, :token, "3c61150b8a52b93a196b641e19addda2155825dc")
  defp url, do: Application.get_env(:giteax, :url, "http://localhost:3000")
end
