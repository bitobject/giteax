defmodule Giteax.Organization.Schemas.OrgRequestParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Organization.Schemas.OrgRequestParams

  @required_fields ~w(username)a

  describe "Org request params test" do
    test "validate/1" do
      all_params = all_params()
      without_req_fields = Map.drop(all_params, @required_fields)

      assert {:error, [username: {"can't be blank", [validation: :required]}]} =
               OrgRequestParams.validate(%{})

      assert {:error, [username: {"can't be blank", [validation: :required]}]} =
               OrgRequestParams.validate(without_req_fields)

      assert {:ok, %OrgRequestParams{username: "some"}} =
               OrgRequestParams.validate(%{username: "some"})

      assert {:ok, struct(OrgRequestParams, all_params)} == OrgRequestParams.validate(all_params)
    end

    test "change/1" do
      error = {:username, {"can't be blank", [validation: :required]}}

      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)
      without_req_fields = Map.drop(all_params, @required_fields)

      assert %Ecto.Changeset{valid?: false, errors: [^error]} = OrgRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: [^error]} =
               OrgRequestParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{username: "some"}} =
               OrgRequestParams.change(%{username: "some"})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{username: "some"}} =
               OrgRequestParams.change(%{username: "some", visibility: "private"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [visibility: {"is invalid", _}],
               changes: %{username: "some"}
             } = OrgRequestParams.change(%{username: "some", visibility: :some})

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               OrgRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = OrgRequestParams.change(all_params)
      empty_changeset = OrgRequestParams.change(%{})

      assert struct(OrgRequestParams, all_params) == OrgRequestParams.apply(changeset)
      assert %OrgRequestParams{} == OrgRequestParams.apply(empty_changeset)
    end
  end

  defp all_params() do
    %{
      description: "description",
      full_name: "full_name",
      location: "location",
      repo_admin_change_team_access: false,
      username: "username",
      visibility: :limited,
      website: "website"
    }
  end
end
