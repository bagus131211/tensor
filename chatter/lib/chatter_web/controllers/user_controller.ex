defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller
  alias Chatter.{User, Repo}

  def index(conn, _params), do: render(conn, "index.html", users: Repo.all(User))

  def show(conn, %{"id" => id}), do: (
    user = Repo.get!(User, id)
    cond do
      user == Guardian.Plug.current_resource(conn) -> render(conn, "show.html", user: user)
      true -> conn |> put_flash(:error, "No access: not your data") |> redirect(to: ~p"/users")
    end
  )

  def new(conn, _params), do: render(conn, "new.html", changeset: User.changeset(%User{}, %{}))

  def create(conn, %{"user" => user}), do: (
    case Repo.insert(User.register_changeset(%User{}, user)), do: (
      {:ok, _user} -> conn |> put_flash(:info, "User created successfully") |> redirect(to: ~p"/users")
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    )
  )

  def edit(conn, %{"id" => id}) do
    user = User |> Repo.get(id)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        changeset = user |> User.changeset(%{})
        render(conn, "edit.html", user: user, changeset: changeset)
      true -> conn |> put_flash(:error, "No access: not your data") |> redirect(to: ~p"/users")
    end
  end

  def update(conn, %{"id" => id, "user" => user}), do: (
    case Repo.update(User |> Repo.get(id) |> User.register_changeset(user)), do: (
      {:ok, _user} -> conn |> put_flash(:info, "User updated successfully") |> redirect(to: ~p"/users/#{id}")
      {:error, changeset} -> render(conn, "edit.html", user: user, changeset: changeset)
    )
  )

  def delete(conn, %{"id" => id}) do
    User |> Repo.get!(id) |> Repo.delete!
    conn |> put_flash(:info, "User deleted successfully") |> redirect(to: ~p"/users")
  end
end
