defmodule Giteax.Admin.Schemas.UserRequestStructsTest do
  use ExUnit.Case, async: true

  alias Giteax.Admin.Schemas.UserRequestStructs

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
              ]} = UserRequestStructs.validate(%{})

      assert {:error,
              [
                {:email, {"can't be blank", [validation: :required]}},
                {:password, {"can't be blank", [validation: :required]}},
                {:username, {"can't be blank", [validation: :required]}}
              ]} ==
               UserRequestStructs.validate(without_req_fields)

      assert {:error, [email: {"has invalid format", [validation: :format]}]} =
               UserRequestStructs.validate(%{
                 username: "some",
                 password: "password",
                 email: "email"
               })

      assert {:ok,
              %UserRequestStructs{username: "some", password: "password", email: "email@mail.com"}} =
               UserRequestStructs.validate(%{
                 username: "some",
                 password: "password",
                 email: "email@mail.com"
               })

      assert {:ok, struct(UserRequestStructs, all_params)} ==
               UserRequestStructs.validate(all_params)
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

      assert %Ecto.Changeset{valid?: false, errors: ^errors} = UserRequestStructs.change(%{})

      assert %Ecto.Changeset{valid?: false, errors: ^errors} =
               UserRequestStructs.change(without_req_fields)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [email: {"has invalid format", [validation: :format]}],
               changes: %{username: "some", password: "password", email: "email"}
             } =
               UserRequestStructs.change(%{username: "some", password: "password", email: "email"})

      assert %Ecto.Changeset{
               valid?: true,
               errors: [],
               changes: %{username: "some", password: "password", email: "email@mail.com"}
             } =
               UserRequestStructs.change(%{
                 username: "some",
                 password: "password",
                 email: "email@mail.com"
               })

      assert %Ecto.Changeset{valid?: true, errors: [], changes: ^all_params} =
               UserRequestStructs.change(params_with_unknown_fields)
    end

    test "apply/1" do
      all_params = all_params()
      changeset = UserRequestStructs.change(all_params)
      empty_changeset = UserRequestStructs.change(%{})

      assert struct(UserRequestStructs, all_params) == UserRequestStructs.apply(changeset)
      assert %UserRequestStructs{} == UserRequestStructs.apply(empty_changeset)
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
