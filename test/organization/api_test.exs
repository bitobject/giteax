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
      assert {:ok, _body} = Giteax.Organization.Api.create_org(test_client(), %{username: "orgs"})
      assert {:ok, _body} = Giteax.Organization.Api.delete_org(test_client(), org: "orgs")
    end

    test "delete_org/3: already insert error" do
      assert {:error,
              %{
                "errors" => ["user redirect does not exist [name: orgs]"],
                "message" => _,
                "url" => _
              }} = Giteax.Organization.Api.delete_org(test_client(), org: "orgs")
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
