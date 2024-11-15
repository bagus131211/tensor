defmodule Scheduler.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scheduler.Accounts.User
  alias Scheduler.Companies.CompaniesUsers

  schema "companies" do
    field :name, :string
    many_to_many :user, User, join_through: CompaniesUsers

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
