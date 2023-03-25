defmodule Giteax.Organization.RequestStructs.RepoParamsTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.RequestStructs.RepoParams

  describe "Repo request params test" do
    test "validate/1" do
      errors = [name: {"can't be blank", [validation: :required]}]

      all_params = build(:repo_params)
      req_fields = build(:repo_params_only_req_fields)
      without_req_fields = build(:repo_params_without_req_fields)

      assert {:error, ^errors} = RepoParams.validate(%{})
      assert {:error, ^errors} = RepoParams.validate(without_req_fields)

      assert {:ok, struct(RepoParams, req_fields)} ==
               RepoParams.validate(req_fields)

      assert {:ok, struct(RepoParams, all_params)} ==
               RepoParams.validate(all_params)
    end

    test "change/1" do
      errors = [name: {"can't be blank", [validation: :required]}]

      all_params = build(:repo_params)
      req_fields = build(:repo_params_only_req_fields)
      without_req_fields = build(:repo_params_without_req_fields)
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = RepoParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               RepoParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^req_fields} =
               RepoParams.change(req_fields)

      assert %Ecto.Changeset{valid?: true, errors: []} =
               RepoParams.change(%{name: "some", trust_model: "committer"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [trust_model: {"is invalid", _}],
               changes: %{name: "some"}
             } = RepoParams.change(%{name: "some", trust_model: :some})

      assert struct(RepoParams, all_params) ==
               params_with_unknown_fields
               |> RepoParams.change()
               |> RepoParams.apply()
    end

    test "apply/1" do
      all_params = build(:repo_params)
      changeset = RepoParams.change(all_params)
      empty_changeset = RepoParams.change(%{})

      assert struct(RepoParams, all_params) == RepoParams.apply(changeset)
      assert %RepoParams{} == RepoParams.apply(empty_changeset)
    end
  end
end
