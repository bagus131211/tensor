defmodule Chat do
  use Application

  def start(_start_type, _start_args) do
    Chat.Supervisor.start
  end
end
