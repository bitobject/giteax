defmodule Giteax.Organization.RequestStructs.OrgParamsTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.RequestStructs.OrgParams

  describe "Org request params test" do
    test "validate/1" do
      errors = [username: {"can't be blank", [validation: :required]}]

      all_params = build(:org_params)
      req_fields = build(:org_params_only_req_fields)
      without_req_fields = build(:org_params_without_req_fields)

      assert {:error, ^errors} = OrgParams.validate(%{})
      assert {:error, ^errors} = OrgParams.validate(without_req_fields)
      assert {:ok, struct(OrgParams, req_fields)} == OrgParams.validate(req_fields)
      assert {:ok, struct(OrgParams, all_params)} == OrgParams.validate(all_params)
    end

    test "change/1" do
      errors = [username: {"can't be blank", [validation: :required]}]

      all_params = build(:org_params)
      req_fields = build(:org_params_only_req_fields)
      without_req_fields = build(:org_params_without_req_fields)
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = OrgParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               OrgParams.change(without_req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^req_fields} =
               OrgParams.change(req_fields)

      assert %Ecto.Changeset{valid?: true, errors: [], changes: %{username: "some"}} =
               OrgParams.change(%{username: "some", visibility: "private"})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [visibility: {"is invalid", _}],
               changes: %{username: "some"}
             } = OrgParams.change(%{username: "some", visibility: :some})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [website: {"has invalid format", _}]
             } = OrgParams.change(%{username: "some", website: "mail.com"})

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
               } = OrgParams.change(%{username: "some", website: website})
      end

      assert struct(OrgParams, all_params) ==
               params_with_unknown_fields
               |> OrgParams.change()
               |> OrgParams.apply()
    end

    test "apply/1" do
      all_params = build(:org_params)
      changeset = OrgParams.change(all_params)
      empty_changeset = OrgParams.change(%{})

      assert struct(OrgParams, all_params) == OrgParams.apply(changeset)
      assert %OrgParams{} == OrgParams.apply(empty_changeset)
    end
  end
end
