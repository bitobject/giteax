defmodule Giteax.Organization.Schemas.RepoRequestParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Organization.Schemas.RepoRequestParams

  @required_fields ~w(name)a

  describe "Repo request params test" do
    test "validate/1" do
      all_params = all_params()
      without_req_fields = Map.drop(all_params, @required_fields)

      assert {:error, [name: {"can't be blank", [validation: :required]}]} =
               RepoRequestParams.validate(%{})

      assert {:error, [name: {"can't be blank", [validation: :required]}]} =
               RepoRequestParams.validate(without_req_fields)

      assert {:ok, %RepoRequestParams{name: "some"}} = RepoRequestParams.validate(%{name: "some"})

      assert {:ok, struct(RepoRequestParams, all_params)} ==
               RepoRequestParams.validate(all_params)
    end

    test "change/1" do
      error = {:name, {"can't be blank", [validation: :required]}}

      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)
      without_req_fields = Map.drop(all_params, @required_fields)

      assert %Ecto.Changeset{valid?: false, errors: [^error]} = RepoRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: [^error]} =
               RepoRequestParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{name: "some"}} =
               RepoRequestParams.change(%{name: "some"})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               RepoRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = RepoRequestParams.change(all_params)
      empty_changeset = RepoRequestParams.change(%{})

      assert struct(RepoRequestParams, all_params) == RepoRequestParams.apply(changeset)
      assert %RepoRequestParams{} == RepoRequestParams.apply(empty_changeset)
    end
  end

  defp all_params() do
    %{
      auto_init: false,
      default_branch: "default_branch",
      description: "description",
      gitignores: "gitignores",
      issue_labels: "issue_labels",
      license: "license",
      name: "name",
      private: false,
      readme: "readme",
      template: true,
      trust_model: :collaborator
    }
  end
end
