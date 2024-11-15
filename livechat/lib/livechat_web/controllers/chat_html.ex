defmodule LivechatWeb.ChatHTML do
  use LivechatWeb, :html

  def message_list(assigns),
    do: ~H"""
    <ul id="msgs">
      <%= for msg <- @messages do %>
        <li><strong><%= msg.username %></strong>: <%= msg.content %></li>
      <% end %>
    </ul>
    """

  def this_form(assigns),
    do: ~H"""
    <.form
      :let={f}
      for={@changeset}
      phx-submit="send_message"
      phx-change="validate"
      autocomplete="off"
    >
      <.label for="user_name">User Name</.label>
       <.input type="text" field={f[:username]} />
      <.label for="message">Message</.label>
       <.input type="text" field={f[:content]} /> <br />
      <div>
        <.button phx-disable-with="Loading...">Send</.button>
      </div>
    </.form>
    """

  embed_templates "chat_html/*"
end
