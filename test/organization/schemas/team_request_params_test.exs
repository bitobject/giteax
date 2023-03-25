defmodule Giteax.Organization.RequestStructs.TeamParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Organization.RequestStructs.TeamParams

  @required_fields ~w(name)a
  @unit_values ~w(repo.code repo.issues repo.ext_issues repo.wiki repo.pulls repo.releases repo.projects repo.ext_wiki)a

  describe "Org request params test" do
    test "validate/1" do
      all_params = all_params()
      without_req_fields = Map.drop(all_params, @required_fields)

      assert {:error, [name: {"can't be blank", [validation: :required]}]} =
               TeamParams.validate(%{})

      assert {:error, [name: {"can't be blank", [validation: :required]}]} =
               TeamParams.validate(without_req_fields)

      assert {:ok, %TeamParams{name: "some"}} = TeamParams.validate(%{name: "some"})

      assert {:ok, struct(TeamParams, all_params)} ==
               TeamParams.validate(all_params)
    end

    test "change/1" do
      error = {:name, {"can't be blank", [validation: :required]}}

      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)
      without_req_fields = Map.drop(all_params, @required_fields)

      assert %Ecto.Changeset{valid?: false, errors: [^error]} = TeamParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: [^error]} =
               TeamParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{name: "some"}} =
               TeamParams.change(%{name: "some"})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{name: "some"}} =
               TeamParams.change(%{name: "some", permission: "write"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [permission: {"is invalid", _}],
               changes: %{name: "some"}
             } = TeamParams.change(%{name: "some", permission: :some})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [units: {"is invalid", _}],
               changes: %{name: "some"}
             } = TeamParams.change(%{name: "some", units: [:"repo.codes"]})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               TeamParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = TeamParams.change(all_params)
      empty_changeset = TeamParams.change(%{})

      assert struct(TeamParams, all_params) == TeamParams.apply(changeset)
      assert %TeamParams{} == TeamParams.apply(empty_changeset)
    end
  end

  defp all_params() do
    %{
      can_create_org_repo: false,
      description: "description",
      includes_all_repositories: false,
      name: "name",
      permission: :read,
      units: @unit_values
    }
  end
end
