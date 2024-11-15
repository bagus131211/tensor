defmodule GraphicalWeb.Plug.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias Graphical.Repo
  alias Graphical.Accounts.User

  def init(opts), do: opts

  def call(conn, _), do: put_private(conn, :absinthe, %{context: conn |> build_context})

  defp build_context(conn),
    do:
      (with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
            {:ok, current_user} <- authorize(token) do
         %{current_user: current_user}
       else
         _ -> %{}
       end)

  defp authorize(token),
    do:
      User
      |> where(token: ^token)
      |> Repo.one()
      |> case(
        do: (
          nil -> {:error, "invalid authorzation token"}
          user -> {:ok, user}
        )
      )
end
