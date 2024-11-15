defmodule SchedulerWeb.SchedulingControllerTest do
  use SchedulerWeb.ConnCase

  import Scheduler.ScheduleFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all schedulings", %{conn: conn} do
      conn = get(conn, ~p"/schedulings")
      assert html_response(conn, 200) =~ "Listing Schedulings"
    end
  end

  describe "new scheduling" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/schedulings/new")
      assert html_response(conn, 200) =~ "New Scheduling"
    end
  end

  describe "create scheduling" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/schedulings", scheduling: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/schedulings/#{id}"

      conn = get(conn, ~p"/schedulings/#{id}")
      assert html_response(conn, 200) =~ "Scheduling #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/schedulings", scheduling: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Scheduling"
    end
  end

  describe "edit scheduling" do
    setup [:create_scheduling]

    test "renders form for editing chosen scheduling", %{conn: conn, scheduling: scheduling} do
      conn = get(conn, ~p"/schedulings/#{scheduling}/edit")
      assert html_response(conn, 200) =~ "Edit Scheduling"
    end
  end

  describe "update scheduling" do
    setup [:create_scheduling]

    test "redirects when data is valid", %{conn: conn, scheduling: scheduling} do
      conn = put(conn, ~p"/schedulings/#{scheduling}", scheduling: @update_attrs)
      assert redirected_to(conn) == ~p"/schedulings/#{scheduling}"

      conn = get(conn, ~p"/schedulings/#{scheduling}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, scheduling: scheduling} do
      conn = put(conn, ~p"/schedulings/#{scheduling}", scheduling: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Scheduling"
    end
  end

  describe "delete scheduling" do
    setup [:create_scheduling]

    test "deletes chosen scheduling", %{conn: conn, scheduling: scheduling} do
      conn = delete(conn, ~p"/schedulings/#{scheduling}")
      assert redirected_to(conn) == ~p"/schedulings"

      assert_error_sent 404, fn ->
        get(conn, ~p"/schedulings/#{scheduling}")
      end
    end
  end

  defp create_scheduling(_) do
    scheduling = scheduling_fixture()
    %{scheduling: scheduling}
  end
end
