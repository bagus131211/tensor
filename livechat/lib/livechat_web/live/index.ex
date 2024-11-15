defmodule LivechatWeb.Live.Index do
  use Phoenix.LiveView

  alias Livechat.Chat
  alias Livechat.Chat.{Message}

  def mount(_params, _session, socket) do
    if connected?(socket), do: Chat.subscribe()
    {:ok, fetch(socket)}
  end

  def render(assigns), do: LivechatWeb.ChatHTML.index(assigns)

  def fetch(socket, user_name \\ nil),
    do:
      assign(socket, %{
        user_name: user_name,
        messages: Chat.list_messages(),
        changeset: Chat.change_message(%Message{username: user_name})
      })

  def handle_event("validate", %{"message" => message_params}, socket),
    do:
      {:noreply,
       assign(socket,
         changeset:
           %Message{}
           |> Chat.change_message(message_params)
           # Triggers validation without saving
           |> Map.put(:action, :validate)
       )}

  # Handle the form submission event
  def handle_event("send_message", %{"message" => message_params}, socket),
    do:
      case(Chat.create_message(message_params),
        do: (
          {:ok, message} ->
            {:noreply, fetch(socket, message.username)}

          {:error, changeset} ->
            {:noreply, assign(socket, changeset: changeset)}
        )
      )

  def handle_info({Chat, [:message, _event_type], _message}, socket),
    do: {:noreply, fetch(socket, get_username(socket))}

  defp get_username(socket), do: socket.assigns |> Map.get(:user_name)
end
