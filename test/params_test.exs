defmodule Giteax.PathParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.PathParams

  describe "PathParams test" do
    test "validate/2" do
      assert {:ok, [org: "org"]} = PathParams.validate([org: "org"], [:org])
      assert {:ok, [org: "org"]} = PathParams.validate([org: "org", some: "some"], [:org])

      assert {:ok, [org: "org", some: "some"]} =
               PathParams.validate([org: "org", some: "some"], [:org, :some])

      assert {:error, %{field: :org, errors: ["expected to be in params"]}} =
               PathParams.validate([some: "some"], [:org, :some])

      assert {:error, %{field: :params, errors: ["expected to be a keyword list"]}} =
               PathParams.validate([:org, :some], [:org, :some])

      assert {:error, %{field: :params, errors: ["expected to be a keyword list"]}} =
               PathParams.validate([], [:org, :some])
    end
  end
end
