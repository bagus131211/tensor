defmodule Graphical.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GraphicalWeb.Telemetry,
      Graphical.Repo,
      {DNSCluster, query: Application.get_env(:graphical, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Graphical.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Graphical.Finch},
      # Start a worker by calling: Graphical.Worker.start_link(arg)
      # {Graphical.Worker, arg},
      # Start to serve requests, typically the last entry
      GraphicalWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Graphical.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphicalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
