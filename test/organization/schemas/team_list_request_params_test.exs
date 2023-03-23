defmodule Giteax.Organization.Schemas.TeamListRequestParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Organization.Schemas.TeamListRequestParams

  describe "TeamList request params test" do
    test "validate/1" do
      all_params = all_params()

      assert {:ok, %TeamListRequestParams{limit: 50, page: 1}} =
               TeamListRequestParams.validate(%{})

      assert {:ok, %TeamListRequestParams{limit: 10, page: 10}} =
               TeamListRequestParams.validate(%{limit: 10, page: 10})

      assert {:ok, struct(TeamListRequestParams, all_params)} ==
               TeamListRequestParams.validate(all_params)
    end

    test "change/1" do
      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: true} = TeamListRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               TeamListRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = TeamListRequestParams.change(all_params)
      empty_changeset = TeamListRequestParams.change(%{})

      assert struct(TeamListRequestParams, all_params) == TeamListRequestParams.apply(changeset)
      assert %TeamListRequestParams{} == TeamListRequestParams.apply(empty_changeset)
    end

    test "to_list/1" do
      base = %TeamListRequestParams{}
      all_params = all_params()
      all_params_struct = struct(TeamListRequestParams, all_params)

      assert [limit: 50, page: 1] == TeamListRequestParams.to_list(base)
      assert [limit: 0, page: 0] == TeamListRequestParams.to_list(all_params)
      assert [limit: 0, page: 0] == TeamListRequestParams.to_list(all_params_struct)
    end
  end

  defp all_params(), do: %{page: 0, limit: 0}
end
