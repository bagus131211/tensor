defmodule Chatter.Auth do
  import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]
  alias Chatter.{User}

  defp login(conn, user), do: conn |> Guardian.Plug.sign_in(Chatter.Guardian, user, %{"typ" => "access"})

  def login_with(conn, email, password, opts) do
    repo = opts |> Keyword.fetch!(:repo)
    user = repo.get_by(User, email: email)

    cond do
      user && verify_pass(password, user.encrypt_pass) -> {:ok, login(conn, user)}
      user -> {:error, :unauthorized, conn}
      true ->
        no_user_verify()
        {:error, :not_found, conn}
    end
  end
end
