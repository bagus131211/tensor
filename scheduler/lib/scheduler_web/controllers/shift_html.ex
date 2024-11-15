defmodule SchedulerWeb.ShiftHTML do
  use SchedulerWeb, :html

  embed_templates "shift_html/*"

  @doc """
  Renders a shift form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def shift_form(assigns)
end
