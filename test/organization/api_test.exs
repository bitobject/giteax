defmodule Giteax.Organization.ApiTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.Api
  alias Giteax.Organization.Schemas.Org
  alias Giteax.Organization.Schemas.Repo

  @api_path "/api/v1"
  @body_data_types [0, -1, 0.0, -1.0, "some", "", [some: :data], [{"some", "data"}], [], %{}]
  @params_data_types [0, -1, 0.0, -1.0, "some", "", %{some: :data}, %{"some" => "data"}, [], %{}]

  describe "Create organization api test" do
    test "create_org/2: success" do
      org_params = build(:org_params)
      assert {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)
    end

    test "create_org/2: already insert error" do
      org_params = build(:org_params)
      error = "user already exists [name: #{org_params.username}]"

      assert {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      assert {:error, %{"message" => ^error, "url" => _}} =
               Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)
    end

    test "create_org/2: invalid body" do
      error = {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Api.create_org(test_client(), data), "data: #{inspect(data)}"
      end
    end

    test "create_org/2: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.create_org(data, %{username: "org"}), "data: #{inspect(data)}"
      end
    end
  end

  describe "Delete organization api test" do
    test "delete_org/2: success" do
      org_params = build(:org_params)
      assert {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      assert {:ok, _body} = Api.delete_org(test_client(), org: org.username)
    end

    test "delete_org/2: already deleted organization" do
      assert {:error,
              %{
                "errors" => ["user redirect does not exist [name: new_org]"],
                "message" => _,
                "url" => _
              }} = Api.delete_org(test_client(), org: "new_org")
    end

    test "delete_org/2: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.delete_org(test_client(), data), "data: #{inspect(data)}"
      end
    end

    test "delete_org/2: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @params_data_types do
        assert error == Api.delete_org(data, org: "org"), "data: #{inspect(data)}"
      end
    end
  end

  describe "Create organization's repository api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)

      %{org: org}
    end

    test "create_org_repo/3: success", %{org: org} do
      assert {:ok, %Repo{} = repo} =
               Api.create_org_repo(test_client(), build(:repo_params), org: org.username)

      on_exit(fn ->
        Giteax.Repository.Api.delete_repo(test_client(), repo: repo.name, owner: org.username)
      end)
    end

    test "create_org_repo/3: already insert error", %{org: org} do
      assert {:ok, %Repo{} = repo} =
               Api.create_org_repo(test_client(), build(:repo_params), org: org.username)

      assert {:error,
              %{
                "message" => "The repository with the same name already exists.",
                "url" => _
              }} = Api.create_org_repo(test_client(), %{name: repo.name}, org: org.username)

      on_exit(fn ->
        Giteax.Repository.Api.delete_repo(test_client(), repo: repo.name, owner: org.username)
      end)
    end

    test "create_org_repo/3: invalid body", %{org: org} do
      error = {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Api.create_org_repo(test_client(), data, org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "create_org_repo/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.create_org_repo(data, build(:repo_params), org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "create_org_repo/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.create_org_repo(test_client(), build(:repo_params), data),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "List organization's teams api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)

      %{org: org}
    end

    test "list_org_team/3: success", %{org: org} do
      assert {:ok, _body} =
               Api.list_org_team(test_client(), %{page_number: 1, limit: 5}, org: org.username)
    end

    test "list_org_team/3: already insert error", %{org: org} do
      assert {:ok, _body} =
               Api.list_org_team(test_client(), %{page_number: 0, limit: 0}, org: org.username)
    end

    test "list_org_team/3: invalid body", %{org: org} do
      error = {:error, %{field: :body, errors: ["expected to be a map"]}}

      for data <- List.delete_at(@body_data_types, -1) do
        assert error == Api.list_org_team(test_client(), data, org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "list_org_team/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.list_org_team(data, %{name: "repo_4"}, org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "list_org_team/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.list_org_team(test_client(), %{name: "repo_5"}, data),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "Create organization's team api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)

      %{org: org}
    end

    test "create_team/3: success", %{org: org} do
      # TODO make body struct and get id for delete
      assert {:ok, body} = Api.create_team(test_client(), %{name: "team_2"}, org: org.username)

      on_exit(fn ->
        Api.delete_team(test_client(), id: body["id"])
      end)
    end

    test "create_team/3: already insert error", %{org: org} do
      # TODO make body struct and get id for delete
      # TODO add org struct and get org id,
      # TODO format tail to [org_id: 592, name: team_3]

      assert {:ok, body} = Api.create_team(test_client(), %{name: "team_3"}, org: org.username)

      assert {:error,
              %{
                "message" => "team already exists " <> _tail,
                "url" => _
              }} = Api.create_team(test_client(), %{name: "team_3"}, org: org.username)

      on_exit(fn ->
        Api.delete_team(test_client(), id: body["id"])
      end)
    end

    test "create_team/3: invalid body", %{org: org} do
      error = {:error, %{field: :body, errors: ["expected to be a non empty map"]}}

      for data <- @body_data_types do
        assert error == Api.create_team(test_client(), data, org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "create_team/3: invalid client", %{org: org} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.create_team(data, %{name: "team_4"}, org: org.username),
               "data: #{inspect(data)}"
      end
    end

    test "create_team/3: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.create_team(test_client(), %{name: "team_5"}, data),
               "data: #{inspect(data)}"
      end
    end
  end

  describe "Delete organization's team api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)

      on_exit(fn ->
        Api.delete_org(test_client(), org: org.username)
      end)

      %{org: org}
    end

    test "delete_team/2: success", %{org: org} do
      # TODO add check with get team
      assert {:ok, body} = Api.create_team(test_client(), %{name: "team_2"}, org: org.username)
      assert {:ok, _body} = Api.delete_team(test_client(), id: body["id"])
    end

    test "delete_team/2: already deleted organization", %{org: org} do
      assert {:ok, body} = Api.create_team(test_client(), %{name: "team_3"}, org: org.username)
      assert {:ok, _body} = Api.delete_team(test_client(), id: body["id"])

      assert {:error,
              %{
                "errors" => nil,
                "message" => "The target couldn't be found.",
                "url" => _
              }} = Api.delete_team(test_client(), id: body["id"])
    end

    test "delete_team/2: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.delete_team(test_client(), data), "data: #{inspect(data)}"
      end
    end

    test "delete_team/2: invalid client" do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @params_data_types do
        assert error == Api.delete_team(data, org: "org"), "data: #{inspect(data)}"
      end
    end
  end

  describe "Add a team member api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)
      {:ok, body} = Api.create_team(test_client(), %{name: "team_2"}, org: org.username)

      {:ok, user} =
        Giteax.Admin.Api.create_user_by_admin(test_client(), %{
          email: "email1@mail.com",
          password: "password",
          username: "username_4"
        })

      on_exit(fn ->
        Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username_4")
        Api.delete_team(test_client(), id: body["id"])
        Api.delete_org(test_client(), org: org.username)
      end)

      %{team: body, user: user}
    end

    test "add_team_member/2: success", %{team: team, user: user} do
      # TODO make body struct and get id for delete
      assert {:ok, _body} =
               Api.add_team_member(test_client(), id: team["id"], username: user["login"])

      on_exit(fn ->
        Api.delete_team_member(test_client(), id: team["id"], username: user["login"])
      end)
    end

    test "add_team_member/2: no error for second attempt", %{team: team, user: user} do
      # TODO make body struct and get id for delete
      # TODO add org struct and get org id,
      # TODO format tail to [org_id: 592, name: team_3]

      assert {:ok, _body} =
               Api.add_team_member(test_client(), id: team["id"], username: user["login"])

      assert {:ok, _body} =
               Api.add_team_member(test_client(), id: team["id"], username: user["login"])

      on_exit(fn ->
        Api.delete_team_member(test_client(), id: team["id"], username: user["login"])
      end)
    end

    test "add_team_member/2: invalid client", %{team: team, user: user} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.add_team_member(data, id: team["id"], username: user["login"]),
               "data: #{inspect(data)}"
      end
    end

    test "add_team_member/2: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.add_team_member(test_client(), data), "data: #{inspect(data)}"
      end
    end
  end

  describe "Remove a team member api test" do
    setup _ do
      org_params = build(:org_params)
      {:ok, %Org{} = org} = Api.create_org(test_client(), org_params)
      {:ok, body} = Api.create_team(test_client(), %{name: "team_2"}, org: org.username)

      {:ok, user} =
        Giteax.Admin.Api.create_user_by_admin(test_client(), %{
          email: "email2@mail.com",
          password: "password",
          username: "username_3"
        })

      on_exit(fn ->
        Giteax.Admin.Api.delete_user_by_admin(test_client(), username: "username_3")
        Api.delete_team(test_client(), id: body["id"])
        Api.delete_org(test_client(), org: org.username)
      end)

      %{team: body, user: user}
    end

    test "delete_team_member/2: success", %{team: team, user: user} do
      # TODO make body struct and get id for delete
      assert {:ok, _body} =
               Api.add_team_member(test_client(), id: team["id"], username: user["login"])

      assert {:ok, _body} =
               Api.delete_team_member(test_client(), id: team["id"], username: user["login"])
    end

    test "delete_team_member/2: no error for second attempt", %{team: team, user: user} do
      # TODO make body struct and get id for delete
      # TODO add org struct and get org id,
      # TODO format tail to [org_id: 592, name: team_3]

      assert {:ok, _body} =
               Api.add_team_member(test_client(), id: team["id"], username: user["login"])

      assert {:ok, _body} =
               Api.delete_team_member(test_client(), id: team["id"], username: user["login"])

      assert {:ok, _body} =
               Api.delete_team_member(test_client(), id: team["id"], username: user["login"])
    end

    test "delete_team_member/2: invalid client", %{team: team, user: user} do
      error = {:error, %{field: :client, errors: ["expected to be %Tesla.Client{} struct"]}}

      for data <- @body_data_types do
        assert error == Api.delete_team_member(data, id: team["id"], username: user["login"]),
               "data: #{inspect(data)}"
      end
    end

    test "delete_team_member/2: invalid params" do
      error = {:error, %{field: :params, errors: ["expected to be a keyword list"]}}

      for data <- @params_data_types do
        assert error == Api.delete_team_member(test_client(), data), "data: #{inspect(data)}"
      end
    end
  end

  # TODO remove
  # test "s" do
  #   for i <- 0..30, j <- 0..5 do
  #     Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_#{j}", owner: "username#{i}")
  #     Giteax.Repository.Api.delete_repo(test_client(), repo: "repo_#{j}", owner: "org#{i}")
  #     Api.delete_org(test_client(), org: "username#{i}")
  #     Api.delete_org(test_client(), org: "org#{i}")
  #   end
  # end

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
