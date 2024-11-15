defmodule Scheduler.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scheduler.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Scheduler.Companies.create_company()

    company
  end
end
