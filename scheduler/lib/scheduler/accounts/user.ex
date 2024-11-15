defmodule Scheduler.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scheduler.Companies.{Company, CompaniesUsers}

  schema "users" do
    field :name, :string
    field :password, :string
    field :email, :string
    many_to_many :company, Company, join_through: CompaniesUsers

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_format(:email, ~r/.+@.+\..+/, message: "Please input a valid email")
    |> unique_constraint(:email)
  end
end
