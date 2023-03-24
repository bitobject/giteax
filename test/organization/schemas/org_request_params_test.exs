defmodule Giteax.Organization.Schemas.OrgRequestParamsTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.Schemas.OrgRequestParams

  describe "Org request params test" do
    test "validate/1" do
      errors = [username: {"can't be blank", [validation: :required]}]

      all_params = build(:org_params)
      req_fields = build(:org_params_only_req_fields)
      without_req_fields = build(:org_params_without_req_fields)

      assert {:error, ^errors} = OrgRequestParams.validate(%{})
      assert {:error, ^errors} = OrgRequestParams.validate(without_req_fields)
      assert {:ok, struct(OrgRequestParams, req_fields)} == OrgRequestParams.validate(req_fields)
      assert {:ok, struct(OrgRequestParams, all_params)} == OrgRequestParams.validate(all_params)
    end

    test "change/1" do
      errors = [username: {"can't be blank", [validation: :required]}]

      all_params = build(:org_params)
      req_fields = build(:org_params_only_req_fields)
      without_req_fields = build(:org_params_without_req_fields)
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = OrgRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               OrgRequestParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^req_fields} =
               OrgRequestParams.change(req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{username: "some"}} =
               OrgRequestParams.change(%{username: "some", visibility: "private"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [visibility: {"is invalid", _}],
               changes: %{username: "some"}
             } = OrgRequestParams.change(%{username: "some", visibility: :some})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [website: {"has invalid format", _}]
             } = OrgRequestParams.change(%{username: "some", website: "mail.com"})

      for website <- [
            "mail.com",
            "www.mail.com",
            "htt//mail.com",
            "https//mail.com",
            "https://mailcom",
            "https://mailcom."
          ] do
        assert %Ecto.Changeset{
                 valid?: false,
                 errors: [website: {"has invalid format", _}]
               } = OrgRequestParams.change(%{username: "some", website: website})
      end

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               OrgRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = build(:org_params)
      changeset = OrgRequestParams.change(all_params)
      empty_changeset = OrgRequestParams.change(%{})

      assert struct(OrgRequestParams, all_params) == OrgRequestParams.apply(changeset)
      assert %OrgRequestParams{} == OrgRequestParams.apply(empty_changeset)
    end
  end
end
