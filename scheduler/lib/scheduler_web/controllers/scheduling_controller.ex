defmodule SchedulerWeb.SchedulingController do
  use SchedulerWeb, :controller

  alias Scheduler.Schedule
  alias Scheduler.Schedule.Scheduling

  def index(conn, _params) do
    schedulings = Schedule.list_schedulings()
    render(conn, :index, schedulings: schedulings)
  end

  def new(conn, _params) do
    changeset = Schedule.change_scheduling(%Scheduling{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"scheduling" => scheduling_params}) do
    case Schedule.create_scheduling(scheduling_params) do
      {:ok, scheduling} ->
        conn
        |> put_flash(:info, "Scheduling created successfully.")
        |> redirect(to: ~p"/schedulings/#{scheduling}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    scheduling = Schedule.get_scheduling!(id)
    render(conn, :show, scheduling: scheduling)
  end

  def edit(conn, %{"id" => id}) do
    scheduling = Schedule.get_scheduling!(id)
    changeset = Schedule.change_scheduling(scheduling)
    render(conn, :edit, scheduling: scheduling, changeset: changeset)
  end

  def update(conn, %{"id" => id, "scheduling" => scheduling_params}) do
    scheduling = Schedule.get_scheduling!(id)

    case Schedule.update_scheduling(scheduling, scheduling_params) do
      {:ok, scheduling} ->
        conn
        |> put_flash(:info, "Scheduling updated successfully.")
        |> redirect(to: ~p"/schedulings/#{scheduling}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, scheduling: scheduling, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    scheduling = Schedule.get_scheduling!(id)
    {:ok, _scheduling} = Schedule.delete_scheduling(scheduling)

    conn
    |> put_flash(:info, "Scheduling deleted successfully.")
    |> redirect(to: ~p"/schedulings")
  end
end
