defmodule SchedulerWeb.SchedulingHTML do
  use SchedulerWeb, :html

  embed_templates "scheduling_html/*"

  @doc """
  Renders a scheduling form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def scheduling_form(assigns)
end
