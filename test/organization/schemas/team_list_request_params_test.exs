defmodule Giteax.Organization.RequestStructs.TeamListParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Organization.RequestStructs.TeamListParams

  describe "TeamList request params test" do
    test "validate/1" do
      all_params = all_params()

      assert {:ok, %TeamListParams{limit: 50, page: 1}} =
               TeamListParams.validate(%{})

      assert {:ok, %TeamListParams{limit: 10, page: 10}} =
               TeamListParams.validate(%{limit: 10, page: 10})

      assert {:ok, struct(TeamListParams, all_params)} ==
               TeamListParams.validate(all_params)

      assert {:ok, %TeamListParams{limit: 10, page: 10}} =
               TeamListParams.validate(%{limit: "10", page: "10"})

      assert {:error, [page: {"is invalid", _}, limit: {"is invalid", _}]} =
               TeamListParams.validate(%{limit: "invalid", page: "invalid"})
    end

    test "change/1" do
      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: true} = TeamListParams.change(%{})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               TeamListParams.change(params_with_unknown_fields)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [page: {"is invalid", _}, limit: {"is invalid", _}]
             } = TeamListParams.change(%{limit: "invalid", page: "invalid"})
    end

    test "apply/1" do
      all_params = all_params()
      changeset = TeamListParams.change(all_params)
      empty_changeset = TeamListParams.change(%{})

      assert struct(TeamListParams, all_params) == TeamListParams.apply(changeset)
      assert %TeamListParams{} == TeamListParams.apply(empty_changeset)
    end

    test "to_list/1" do
      base = %TeamListParams{}
      all_params = all_params()
      all_params_struct = struct(TeamListParams, all_params)

      assert [limit: 50, page: 1] == TeamListParams.to_list(base)
      assert [limit: 0, page: 0] == TeamListParams.to_list(all_params)
      assert [limit: 0, page: 0] == TeamListParams.to_list(all_params_struct)
    end
  end

  defp all_params(), do: %{page: 0, limit: 0}
end
