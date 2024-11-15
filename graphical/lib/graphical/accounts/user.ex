defmodule Graphical.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Graphical.Posts.Post
  alias Graphical.Accounts.User
  alias Graphical.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :token, :string
    has_many :posts, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  def update_changeset(user, attrs),
    do:
      user
      |> cast(attrs, [:name, :email, :password])
      |> validate_required([:name, :email])
      |> hash

  def registration_changeset(user, attrs),
    do:
      user
      |> cast(attrs, [:name, :email, :password])
      |> validate_required([:name, :email, :password])
      |> hash

  def store_token_changeset(user, attrs),
    do: user |> cast(attrs, [:token]) |> validate_required([:token]) |> hash

  defp hash(changeset),
    do:
      case(changeset,
        do: (
          %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
            put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))

          _ ->
            changeset
        )
      )

  def authenticate(attrs) do
    user = Repo.get_by(User, email: String.downcase(attrs.email))

    case check_password(user, attrs.password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credentials"}
    end
  end

  defp check_password(user, password),
    do:
      case(user,
        do: (
          nil -> false
          _ -> Bcrypt.verify_pass(password, user.password_hash)
        )
      )
end
