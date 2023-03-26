defmodule Giteax.Organization.Schemas.OrgTest do
  use ExUnit.Case, async: true

  import Giteax.Support.OrganizationFactory

  alias Giteax.Organization.Schemas.Org

  describe "Org struct test" do
    test "process/1" do
      all_params = build(:org_params)
      req_fields = build(:org_params_only_req_fields)
      without_req_fields = build(:org_params_without_req_fields)

      assert %Org{} = Org.process(%{})
      refute Org.process(nil)
      assert struct(Org, without_req_fields) == Org.process(without_req_fields)
      assert struct(Org, req_fields) == Org.process(req_fields)
      assert struct(Org, all_params) == Org.process(all_params)
    end
  end
end
