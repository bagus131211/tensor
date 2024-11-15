defmodule SchedulerWeb.CompanyHTML do
  use SchedulerWeb, :html

  embed_templates "company_html/*"

  @doc """
  Renders a company form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def company_form(assigns)
end
