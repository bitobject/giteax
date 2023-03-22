defmodule Giteax.Admin.Schemas.UserRequestParamsTest do
  use ExUnit.Case, async: true

  alias Giteax.Admin.Schemas.UserRequestParams

  @required_fields ~w(email password username)a

  describe "Org request params test" do
    test "validate/1" do
      all_params = all_params()
      without_req_fields = Map.drop(all_params, @required_fields)

      assert {:error,
              [
                {:email, {"can't be blank", [validation: :required]}},
                {:password, {"can't be blank", [validation: :required]}},
                {:username, {"can't be blank", [validation: :required]}}
              ]} = UserRequestParams.validate(%{})

      assert {:error,
              [
                {:email, {"can't be blank", [validation: :required]}},
                {:password, {"can't be blank", [validation: :required]}},
                {:username, {"can't be blank", [validation: :required]}}
              ]} ==
               UserRequestParams.validate(without_req_fields)

      assert {:error, [email: {"has invalid format", [validation: :format]}]} =
               UserRequestParams.validate(%{
                 username: "some",
                 password: "password",
                 email: "email"
               })

      assert {:ok,
              %UserRequestParams{username: "some", password: "password", email: "email@mail.com"}} =
               UserRequestParams.validate(%{
                 username: "some",
                 password: "password",
                 email: "email@mail.com"
               })

      assert {:ok, struct(UserRequestParams, all_params)} ==
               UserRequestParams.validate(all_params)
    end

    test "change/1" do
      errors = [
        {:email, {"can't be blank", [validation: :required]}},
        {:password, {"can't be blank", [validation: :required]}},
        {:username, {"can't be blank", [validation: :required]}}
      ]

      all_params = all_params()
      params_with_unknown_fields = Map.put(all_params, :some_field, 5)
      without_req_fields = Map.drop(all_params, @required_fields)

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = UserRequestParams.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               UserRequestParams.change(without_req_fields)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [email: {"has invalid format", [validation: :format]}],
               changes: %{username: "some", password: "password", email: "email"}
             } =
               UserRequestParams.change(%{username: "some", password: "password", email: "email"})

      assert %Ecto.Changeset{
               valid?: true,
               errors: [],
               changes: %{username: "some", password: "password", email: "email@mail.com"}
             } =
               UserRequestParams.change(%{
                 username: "some",
                 password: "password",
                 email: "email@mail.com"
               })

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               UserRequestParams.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = UserRequestParams.change(all_params)
      empty_changeset = UserRequestParams.change(%{})

      assert struct(UserRequestParams, all_params) == UserRequestParams.apply(changeset)
      assert %UserRequestParams{} == UserRequestParams.apply(empty_changeset)
    end
  end

  defp all_params() do
    %{
      email: "email@mail.com",
      full_name: "full_name",
      login_name: "login_name",
      must_change_password: true,
      password: "password",
      send_notify: true,
      source_id: 0,
      username: "username",
      visibility: "visibility"
    }
  end
end
