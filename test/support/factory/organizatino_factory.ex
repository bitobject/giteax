defmodule Giteax.Support.OrganizationFactory do
  @moduledoc false

  use ExMachina

  @spec org_params_factory :: map()
  def org_params_factory do
    %{
      description: sequence("description"),
      full_name: sequence("full_name"),
      location: sequence("location"),
      repo_admin_change_team_access: sequence(:repo_admin_change_team_access, [true, false]),
      username: sequence("org"),
      visibility: sequence(:visibility, ~w(public limited private)a),
      website: sequence(:website, &"http://website#{&1}@mail.com")
    }
  end

  @spec org_params_without_req_fields_factory :: map()
  def org_params_without_req_fields_factory do
    %{
      description: sequence("description"),
      full_name: sequence("full_name"),
      location: sequence("location"),
      repo_admin_change_team_access: sequence(:repo_admin_change_team_access, [true, false]),
      visibility: sequence(:visibility, ~w(public limited private)a),
      website: sequence(:website, &"http://website#{&1}@mail.com")
    }
  end

  @spec org_params_only_req_fields_factory :: map()
  def org_params_only_req_fields_factory, do: %{username: sequence("org")}

  @spec repo_params_factory :: map()
  def repo_params_factory do
    %{
      auto_init: sequence(:auto_init, [true, false]),
      default_branch: sequence("default_branch"),
      description: sequence("description"),
      name: sequence("repo"),
      private: sequence(:private, [false, true]),
      template: false,
      trust_model:
        sequence(:trust_model, ~w(default collaborator committer collaboratorcommitter)a)
    }
  end

  @spec repo_params_without_req_fields_factory :: map()
  def repo_params_without_req_fields_factory do
    %{
      auto_init: sequence(:auto_init, [true, false]),
      default_branch: sequence("default_branch"),
      description: sequence("description"),
      private: sequence(:private, [false, true]),
      template: false,
      trust_model:
        sequence(:trust_model, ~w(default collaborator committer collaboratorcommitter)a)
    }
  end

  @spec repo_params_only_req_fields_factory :: map()
  def repo_params_only_req_fields_factory, do: %{name: sequence("repo")}
end
