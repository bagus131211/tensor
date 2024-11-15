defmodule Scheduler.Companies.CompaniesUsers do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scheduler.Accounts.User
  alias Scheduler.Companies.Company

  @default_relationship :member

  schema "companies_users" do
    has_one :company, Company
    has_one :user, User
    field :relationship, :string
  end

  @doc false
  def changeset(companies_users, attrs),
    do:
      companies_users
      |> cast(attrs, [:company, :user, :relationship])
      |> validate_required([:company, :user, :relationship])
      |> put_change(:relationship, @default_relationship)
      |> validate_inclusion(:relationship, [@default_relationship])
      |> unique_constraint(:company, name: "companies_users_index")
end
