defmodule SchedulerWeb.CompanyController do
  use SchedulerWeb, :controller

  alias Scheduler.Companies
  alias Scheduler.Companies.Company

  def index(conn, _params) do
    companies = Companies.list_companies()
    render(conn, :index, companies: companies)
  end

  def new(conn, _params) do
    changeset = Companies.change_company(%Company{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    case Companies.create_company(company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    render(conn, :show, company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    changeset = Companies.change_company(company)
    render(conn, :edit, company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    {:ok, _company} = Companies.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: ~p"/companies")
  end
end
