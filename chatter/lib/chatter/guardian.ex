defmodule Chatter.Guardian do
  use Guardian, otp_app: :chatter

  alias Chatter.{Repo, User}

  def subject_for_token(%User{} = user, _claims), do: {:ok, "User:#{user.id}"}

  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => "User:" <> id}), do: {:ok, Repo.get(User, id)}

  def resource_from_claims(_), do: {:error, "Unknown resource type"}
end
