defmodule PlugAndCowboy do
  use Application
  require Logger

  def start(_start_type, _start_args) do
    port = Application.get_env(:plug_and_cowboy, :cowboy_port, 4000)
    children = [
      {Plug.Cowboy, scheme: :http, plug: PlugAndCowboy.Router, options: [port: port]}
    ]
    Logger.info "App started!"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
