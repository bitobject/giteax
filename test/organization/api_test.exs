defmodule Giteax.Organization.ApiTest do
  use ExUnit.Case, async: true

  @api_path "/api/v1"
  @body_data_types [0, -1, 0.0, -1.0, "some", "", [some: :data], [{"some", "data"}], [], %{}]
  @params_data_types [0, -1, 0.0, -1.0, "some", "", %{some: :data}, %{"some" => "data"}, [], %{}]

  describe "Create organization api test" do
    test "create_org/3: success" do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org(test_client(), %{username: "username"})

      on_exit(fn ->
        Giteax.Organization.Api.delete_org(test_client(), org: "username")
      end)
    end

    test "create_org/3: already insert error" do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org(test_client(), %{username: "some_username"})

      assert {:error,
              %{
                "message" => "user already exists [name: some_username]",
                "url" => _
              }} = Giteax.Organization.Api.create_org(test_client(), %{username: "some_username"})

      on_exit(fn ->
        Giteax.Organization.Api.delete_org(test_client(), org: "some_username")
      end)
    end

    test "create_org/3: invalid body" do
      error = {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Giteax.Organization.Api.create_org(test_client(), data),
               "data: #{inspect(data)}"
      end
    end

    test "create_org/3: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Giteax.Organization.Api.create_org(data, %{username: "username"}),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "Delete organization api test" do
    test "delete_org/3: success" do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org(test_client(), %{username: "new_org_1"})

      assert {:ok, _body} = Giteax.Organization.Api.delete_org(test_client(), org: "new_org_1")
    end

    test "delete_org/3: already deleted organization" do
      assert {:error,
              %{
                "errors" => ["user redirect does not exist [name: new_org]"],
                "message" => _,
                "url" => _
              }} = Giteax.Organization.Api.delete_org(test_client(), org: "new_org")
    end

    test "delete_org/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Giteax.Organization.Api.delete_org(test_client(), data),
               "data: #{inspect(data)}"
      end
    end

    test "delete_org/3: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @params_data_types do
        assert error == Giteax.Organization.Api.delete_org(data, org: "org"),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "Create organization's repository api test" do
    setup _ do
      {:ok, _body} = Giteax.Organization.Api.create_org(test_client(), %{username: "org_1"})

      on_exit(fn ->
        Giteax.Organization.Api.delete_org(test_client(), org: "org_1")
      end)

      %{org: "org_1"}
    end

    test "create_org_repo/3: success", %{org: org} do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org_repo(test_client(), %{name: "repo_2"}, org: org)

      on_exit(fn ->
        Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_2", owner: org)
      end)
    end

    test "create_org_repo/3: already insert error", %{org: org} do
      assert {:ok, _body} =
               Giteax.Organization.Api.create_org_repo(test_client(), %{name: "repo_3"}, org: org)

      assert {:error,
              %{
                "message" => "The repository with the same name already exists.",
                "url" => _
              }} =
               Giteax.Organization.Api.create_org_repo(test_client(), %{name: "repo_3"}, org: org)

      on_exit(fn ->
        Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_3", owner: org)
      end)
    end

    test "create_org_repo/3: invalid body", %{org: org} do
      error = {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Giteax.Organization.Api.create_org_repo(test_client(), data, org: org),
               "data: #{inspect(data)}"
      end
    end

    test "create_org_repo/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error ==
                 Giteax.Organization.Api.create_org_repo(data, %{name: "repo_4"}, org: org),
               "data: #{inspect(data)}"
      end
    end

    test "create_org_repo/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error ==
                 Giteax.Organization.Api.create_org_repo(
                   test_client(),
                   %{name: "repo_5"},
                   data
                 ),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "List organization's teams api test" do
    setup _ do
      {:ok, _body} = Giteax.Organization.Api.create_org(test_client(), %{username: "org_2"})

      on_exit(fn ->
        Giteax.Organization.Api.delete_org(test_client(), org: "org_2")
      end)

      %{org: "org_2"}
    end

    test "list_org_team/3: success", %{org: org} do
      assert {:ok, _body} =
               Giteax.Organization.Api.list_org_team(test_client(), %{page_number: 1, limit: 5},
                 org: org
               )
    end

    test "list_org_team/3: already insert error", %{org: org} do
      assert {:ok, _body} =
               Giteax.Organization.Api.list_org_team(test_client(), %{page_number: 0, limit: 0},
                 org: org
               )
    end

    test "list_org_team/3: invalid body", %{org: org} do
      error = {:error, %{field: :body, errors: ["expected to be a map"]}}

      for data <- List.delete_at(@body_data_types, -1) do
        assert error == Giteax.Organization.Api.list_org_team(test_client(), data, org: org),
               "data: #{inspect(data)}"
      end
    end

    test "list_org_team/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error ==
                 Giteax.Organization.Api.list_org_team(data, %{name: "repo_4"}, org: org),
               "data: #{inspect(data)}"
      end
    end

    test "list_org_team/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error ==
                 Giteax.Organization.Api.list_org_team(
                   test_client(),
                   %{name: "repo_5"},
                   data
                 ),
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
