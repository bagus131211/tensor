defmodule SchedulerWeb.CompanyControllerTest do
  use SchedulerWeb.ConnCase

  import Scheduler.CompaniesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, ~p"/companies")
      assert html_response(conn, 200) =~ "Listing Companies"
    end
  end

  describe "new company" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/companies/new")
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "create company" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/companies", company: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/companies/#{id}"

      conn = get(conn, ~p"/companies/#{id}")
      assert html_response(conn, 200) =~ "Company #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/companies", company: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{conn: conn, company: company} do
      conn = get(conn, ~p"/companies/#{company}/edit")
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/companies/#{company}", company: @update_attrs)
      assert redirected_to(conn) == ~p"/companies/#{company}"

      conn = get(conn, ~p"/companies/#{company}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/companies/#{company}", company: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, ~p"/companies/#{company}")
      assert redirected_to(conn) == ~p"/companies"

      assert_error_sent 404, fn ->
        get(conn, ~p"/companies/#{company}")
      end
    end
  end

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end
end
