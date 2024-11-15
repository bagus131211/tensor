defmodule Graphical.UserResolver do
  alias Graphical.Accounts

  def all(_args, _info), do: {:ok, Accounts.list_users()}

  def find(%{id: id}, _info),
    do:
      case(Accounts.get_user!(id),
        do: (
          nil -> {:error, "User with id #{id} not found"}
          user -> {:ok, user}
        )
      )

  def update(%{id: id, user: user_params}, _info),
    do: Accounts.get_user!(id) |> Accounts.update_user(user_params)

  def login(args, _info) do
    with {:ok, user} <- Accounts.User.authenticate(args),
         {:ok, jwt, _} <- Graphical.Guardian.encode_and_sign(user),
         {:ok, _} <- Accounts.store_user(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end
end
