defmodule ChatterWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use ChatterWeb, :controller` and
  `use ChatterWeb, :live_view`.
  """
  use ChatterWeb, :html

  def logged(assigns) do
    ~H"""
      <%= if logged_in?(@conn) do %>
          <.link href={~p"/sessions/#{current_user(@conn)}"} method="delete">Sign out</.link>
          <.link navigate={~p"/users/#{current_user(@conn)}"}><%= "#{current_user(@conn).email}" %></.link>
      <% else %>
          <.link navigate={~p"/users/new"}>Create an Account!</.link>
          <.link navigate={~p"/"}>Sign in</.link>
      <% end %>
    """
  end

  embed_templates "layouts/*"
end
