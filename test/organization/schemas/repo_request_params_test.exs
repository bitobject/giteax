defmodule Giteax.Organization.Schemas.RepoRequestParamsTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.Schemas.RepoRequestParams

  describe "Repo request params test" do
    test "validate/1" do
      errors = [name: {"can't be blank", [validation: :required]}]

      all_params = build(:repo_params)
      req_fields = build(:repo_params_only_req_fields)
      without_req_fields = build(:repo_params_without_req_fields)

      assert {:error, ^errors} = RepoRequestParams.validate(%{})
      assert {:error, ^errors} = RepoRequestParams.validate(without_req_fields)
      assert {:ok, struct(RepoRequestParams, req_fields)} == RepoRequestParams.validate(req_fields)
      assert {:ok, struct(RepoRequestParams, all_params)} == RepoRequestParams.validate(all_params)
    end

    test "change/1" do
      errors = [name: {"can't be blank", [validation: :required]}]

      all_params = build(:repo_params)
      req_fields = build(:repo_params_only_req_fields)
      without_req_fields = build(:repo_params_without_req_fields)
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = RepoRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               RepoRequestParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^req_fields} = RepoRequestParams.change(req_fields)

      assert %Ecto.Changeset{valid?: true, errors: []} = RepoRequestParams.change(%{name: "some", trust_model: "committer"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [trust_model: {"is invalid", _}],
               changes: %{name: "some"}
             } = RepoRequestParams.change(%{name: "some", trust_model: :some})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               RepoRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = build(:repo_params)
      changeset = RepoRequestParams.change(all_params)
      empty_changeset = RepoRequestParams.change(%{})

      assert struct(RepoRequestParams, all_params) == RepoRequestParams.apply(changeset)
      assert %RepoRequestParams{} == RepoRequestParams.apply(empty_changeset)
    end
  end
end
