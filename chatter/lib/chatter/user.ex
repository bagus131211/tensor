defmodule Chatter.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrypt_pass, :string
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def register_changeset(user, attrs), do:
    user
    |> changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 5)
    |> hash

  defp hash(changeset), do: (
    case changeset, do: (
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
         put_change(changeset, :encrypt_pass, Bcrypt.hash_pwd_salt(password))
      _ -> changeset
    )
  )
end
