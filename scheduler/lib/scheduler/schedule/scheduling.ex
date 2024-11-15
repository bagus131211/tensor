defmodule Scheduler.Schedule.Scheduling do
  use Ecto.Schema
  import Ecto.Changeset

  alias Scheduler.Companies.Company

  schema "schedulings" do
    field :name, :string
    belongs_to :company, Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(scheduling, attrs) do
    scheduling
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name, :company_id])
  end
end
