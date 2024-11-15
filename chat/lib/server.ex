defmodule Chat.Server do
  use GenServer

  # client
  # with pid
  # def start, do: GenServer.start_link(__MODULE__, [])

  # def get_msg(pid), do: GenServer.call(pid, :get_msg)

  # def add_msg(pid, msg), do: GenServer.cast(pid, {:add_msg, msg})

  # with name
  def start, do: GenServer.start_link(__MODULE__, [], name: :chat_room)

  def get_msg, do: GenServer.call(:chat_room, :get_msg)

  def add_msg(msg), do: GenServer.cast(:chat_room, {:add_msg, msg})

  # server
  def init(msg), do: {:ok, msg}

  def handle_call(:get_msg, _from, msg), do: {:reply, msg, msg}

  def handle_cast({:add_msg, msg}, msgs), do: {:noreply, [msg | msgs] |> Enum.reverse}

end
