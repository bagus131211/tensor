defmodule Chatter.Token do
  use ChatterWeb, :controller
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, opts) do
    IO.inspect({type, reason, opts})
    conn |> put_flash(:error, "You must be signed in!") |> redirect(to: ~p"/")
  end
end
