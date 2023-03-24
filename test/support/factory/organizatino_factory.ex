defmodule Giteax.Support.OrganizationFactory do
  @moduledoc false

  use ExMachina

  @spec org_params_factory :: map()
  def org_params_factory do
    %{
      description: sequence("description"),
      full_name: sequence("full_name"),
      location: sequence("location"),
      repo_admin_change_team_access: false,
      username: sequence("username"),
      visibility: sequence(:visibility, ~w(limited private)a),
      website: sequence(:website, &"http://website#{&1}@mail.com")
    }
  end

  @spec org_params_without_req_fields_factory :: map()
  def org_params_without_req_fields_factory do
    %{
      description: sequence("description"),
      full_name: sequence("full_name"),
      location: sequence("location"),
      repo_admin_change_team_access: false,
      visibility: sequence(:visibility, ~w(limited private)a),
      website: sequence(:website, &"http://website#{&1}@mail.com")
    }
  end

  @spec org_params_only_req_fields_factory :: map()
  def org_params_only_req_fields_factory, do: %{username: sequence("username")}
end
