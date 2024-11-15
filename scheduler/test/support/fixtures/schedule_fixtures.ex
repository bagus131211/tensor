defmodule Scheduler.ScheduleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Scheduler.Schedule` context.
  """

  @doc """
  Generate a shift.
  """
  def shift_fixture(attrs \\ %{}) do
    {:ok, shift} =
      attrs
      |> Enum.into(%{
        end_time: ~N[2024-11-11 06:09:00],
        start_time: ~N[2024-11-11 06:09:00]
      })
      |> Scheduler.Schedule.create_shift()

    shift
  end

  @doc """
  Generate a scheduling.
  """
  def scheduling_fixture(attrs \\ %{}) do
    {:ok, scheduling} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Scheduler.Schedule.create_scheduling()

    scheduling
  end
end
