defmodule Scheduler.ScheduleTest do
  use Scheduler.DataCase

  alias Scheduler.Schedule

  describe "shifts" do
    alias Scheduler.Schedule.Shift

    import Scheduler.ScheduleFixtures

    @invalid_attrs %{start_time: nil, end_time: nil}

    test "list_shifts/0 returns all shifts" do
      shift = shift_fixture()
      assert Schedule.list_shifts() == [shift]
    end

    test "get_shift!/1 returns the shift with given id" do
      shift = shift_fixture()
      assert Schedule.get_shift!(shift.id) == shift
    end

    test "create_shift/1 with valid data creates a shift" do
      valid_attrs = %{start_time: ~N[2024-11-11 06:09:00], end_time: ~N[2024-11-11 06:09:00]}

      assert {:ok, %Shift{} = shift} = Schedule.create_shift(valid_attrs)
      assert shift.start_time == ~N[2024-11-11 06:09:00]
      assert shift.end_time == ~N[2024-11-11 06:09:00]
    end

    test "create_shift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_shift(@invalid_attrs)
    end

    test "update_shift/2 with valid data updates the shift" do
      shift = shift_fixture()
      update_attrs = %{start_time: ~N[2024-11-12 06:09:00], end_time: ~N[2024-11-12 06:09:00]}

      assert {:ok, %Shift{} = shift} = Schedule.update_shift(shift, update_attrs)
      assert shift.start_time == ~N[2024-11-12 06:09:00]
      assert shift.end_time == ~N[2024-11-12 06:09:00]
    end

    test "update_shift/2 with invalid data returns error changeset" do
      shift = shift_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_shift(shift, @invalid_attrs)
      assert shift == Schedule.get_shift!(shift.id)
    end

    test "delete_shift/1 deletes the shift" do
      shift = shift_fixture()
      assert {:ok, %Shift{}} = Schedule.delete_shift(shift)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_shift!(shift.id) end
    end

    test "change_shift/1 returns a shift changeset" do
      shift = shift_fixture()
      assert %Ecto.Changeset{} = Schedule.change_shift(shift)
    end
  end

  describe "schedulings" do
    alias Scheduler.Schedule.Scheduling

    import Scheduler.ScheduleFixtures

    @invalid_attrs %{name: nil}

    test "list_schedulings/0 returns all schedulings" do
      scheduling = scheduling_fixture()
      assert Schedule.list_schedulings() == [scheduling]
    end

    test "get_scheduling!/1 returns the scheduling with given id" do
      scheduling = scheduling_fixture()
      assert Schedule.get_scheduling!(scheduling.id) == scheduling
    end

    test "create_scheduling/1 with valid data creates a scheduling" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Scheduling{} = scheduling} = Schedule.create_scheduling(valid_attrs)
      assert scheduling.name == "some name"
    end

    test "create_scheduling/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_scheduling(@invalid_attrs)
    end

    test "update_scheduling/2 with valid data updates the scheduling" do
      scheduling = scheduling_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Scheduling{} = scheduling} = Schedule.update_scheduling(scheduling, update_attrs)
      assert scheduling.name == "some updated name"
    end

    test "update_scheduling/2 with invalid data returns error changeset" do
      scheduling = scheduling_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_scheduling(scheduling, @invalid_attrs)
      assert scheduling == Schedule.get_scheduling!(scheduling.id)
    end

    test "delete_scheduling/1 deletes the scheduling" do
      scheduling = scheduling_fixture()
      assert {:ok, %Scheduling{}} = Schedule.delete_scheduling(scheduling)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_scheduling!(scheduling.id) end
    end

    test "change_scheduling/1 returns a scheduling changeset" do
      scheduling = scheduling_fixture()
      assert %Ecto.Changeset{} = Schedule.change_scheduling(scheduling)
    end
  end
end
