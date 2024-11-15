defmodule Chat.Supervisor do
  use Supervisor

  def start, do: Supervisor.start_link(__MODULE__, [])

  def init(_init_arg) do
    children = [
      %{id: Chat.Server, start: {Chat.Server, :start, []}}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
