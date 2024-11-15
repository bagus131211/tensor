defmodule Graphical.PostResolver do
  import Ecto.Query, only: [where: 2]
  alias Graphical.Posts
  alias Graphical.Posts.Post
  alias Graphical.Repo

  def all(_args, %{context: %{current_user: %{id: id}}}),
    do: {:ok, Post |> where(user_id: ^id) |> Repo.all()}

  def all(_args, _info), do: {:error, "Not authorized"}

  def create(args, %{context: %{current_user: _current_user}}), do: Posts.create_post(args)

  def create(_args, _info), do: {:error, "Not authorized"}

  def update(%{id: id, post: post_params}, _info),
    do: Posts.get_post!(id) |> Posts.update_post(post_params)

  def delete(%{id: id}, _info), do: Posts.get_post!(id) |> Posts.delete_post()
end
