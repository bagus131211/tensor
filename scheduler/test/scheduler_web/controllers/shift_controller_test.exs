defmodule SchedulerWeb.ShiftControllerTest do
  use SchedulerWeb.ConnCase

  import Scheduler.ScheduleFixtures

  @create_attrs %{start_time: ~N[2024-11-11 06:09:00], end_time: ~N[2024-11-11 06:09:00]}
  @update_attrs %{start_time: ~N[2024-11-12 06:09:00], end_time: ~N[2024-11-12 06:09:00]}
  @invalid_attrs %{start_time: nil, end_time: nil}

  describe "index" do
    test "lists all shifts", %{conn: conn} do
      conn = get(conn, ~p"/shifts")
      assert html_response(conn, 200) =~ "Listing Shifts"
    end
  end

  describe "new shift" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/shifts/new")
      assert html_response(conn, 200) =~ "New Shift"
    end
  end

  describe "create shift" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/shifts", shift: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/shifts/#{id}"

      conn = get(conn, ~p"/shifts/#{id}")
      assert html_response(conn, 200) =~ "Shift #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/shifts", shift: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Shift"
    end
  end

  describe "edit shift" do
    setup [:create_shift]

    test "renders form for editing chosen shift", %{conn: conn, shift: shift} do
      conn = get(conn, ~p"/shifts/#{shift}/edit")
      assert html_response(conn, 200) =~ "Edit Shift"
    end
  end

  describe "update shift" do
    setup [:create_shift]

    test "redirects when data is valid", %{conn: conn, shift: shift} do
      conn = put(conn, ~p"/shifts/#{shift}", shift: @update_attrs)
      assert redirected_to(conn) == ~p"/shifts/#{shift}"

      conn = get(conn, ~p"/shifts/#{shift}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, shift: shift} do
      conn = put(conn, ~p"/shifts/#{shift}", shift: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Shift"
    end
  end

  describe "delete shift" do
    setup [:create_shift]

    test "deletes chosen shift", %{conn: conn, shift: shift} do
      conn = delete(conn, ~p"/shifts/#{shift}")
      assert redirected_to(conn) == ~p"/shifts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/shifts/#{shift}")
      end
    end
  end

  defp create_shift(_) do
    shift = shift_fixture()
    %{shift: shift}
  end
end
