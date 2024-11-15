defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller
  import Chatter.Auth

  def new(conn, _params), do: render(conn, "new.html")

  def create(conn, %{"session" => %{"email" => user, "password" => password}}), do: (
    case login_with(conn, user, password, repo: Chatter.Repo), do: (
      {:ok, conn} ->
        Guardian.Plug.current_resource(conn)
        conn |> put_flash(:info, "logged in!") |> redirect(to: ~p"/chat")
      {:error, _reason, conn} ->
        conn |> put_flash(:error, "Wrong username or password") |> render("new.html")
    )
  )

  def delete(conn, _params), do: conn |> Guardian.Plug.sign_out(Chatter.Guardian) |> redirect(to: ~p"/")
end
