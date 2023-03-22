defmodule Giteax.Admin.ApiTest do
  use ExUnit.Case, async: true

  @api_path "/api/v1"
  @body_data_types [0, -1, 0.0, -1.0, "some", "", [some: :data], [{"some", "data"}], [], %{}]
  @params_data_types [0, -1, 0.0, -1.0, "some", "", %{some: :data}, %{"some" => "data"}, [], %{}]

  describe "Create user by admin api test" do
    test "create_user_by_admin23: success" do
      assert {:ok, _body} =
               Giteax.Admin.Api.create_user_by_admin(test_client(), %{
                 email: "email@mail.com",
                 password: "password",
                 username: "username"
               })

      on_exit(fn ->
        Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username")
      end)
    end

    test "create_user_by_admin23: already insert error" do
      assert {:ok, _body} =
               Giteax.Admin.Api.create_user_by_admin(test_client(), %{
                 email: "email_1@mail.com",
                 password: "password",
                 username: "username_1"
               })

      assert {:error,
              %{
                "message" => "user already exists [name: username_1]",
                "url" => _
              }} =
               Giteax.Admin.Api.create_user_by_admin(test_client(), %{
                 email: "email_1@mail.com",
                 password: "password",
                 username: "username_1"
               })

      on_exit(fn ->
        Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username_1")
      end)
    end

    test "create_user_by_admin23: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Giteax.Admin.Api.create_user_by_admin(test_client(), data),
               "data: #{inspect(data)}"
      end
    end

    test "create_user_by_admin23: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error ==
                 Giteax.Admin.Api.create_user_by_admin(data, %{
                   email: "email",
                   password: "password",
                   username: "username"
                 }),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "Delete user by admin api test" do
    test "delete_user_by_admin22: success" do
      assert {:ok, _body} =
               Giteax.Admin.Api.create_user_by_admin(test_client(), %{
                 email: "email_2@mail.com",
                 password: "password",
                 username: "username_2"
               })

      assert {:ok, _body} =
               Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username_2")
    end

    test "delete_user_by_admin22: already deleted user" do
      assert {:error,
              %{
                "message" => "user redirect does not exist [name: username_2]",
                "url" => _
              }} = Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username_2")
    end

    test "delete_user_by_admin22: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Giteax.Admin.Api.delete_user_by_admin(test_client(), data),
               "data: #{inspect(data)}"
      end
    end

    test "delete_user_by_admin22: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @params_data_types do
        assert error == Giteax.Admin.Api.delete_user_by_admin(data, org: "org"),
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
