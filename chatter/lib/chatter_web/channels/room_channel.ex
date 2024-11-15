defmodule ChatterWeb.RoomChannel do
  use ChatterWeb, :channel
  alias ChatterWeb.Presence

  @impl true
  def join("room:lobby", _payload, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: System.system_time(:millisecond)
    })
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("message:new", message, socket) do
    broadcast(socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: System.system_time(:millisecond)
    })
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
