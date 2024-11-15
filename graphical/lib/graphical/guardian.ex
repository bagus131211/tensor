defmodule Graphical.Guardian do
  use Guardian, otp_app: :graphical
  alias Graphical.Accounts

  def subject_for_token(%Accounts.User{} = user, _claims), do: {:ok, to_string(user.id)}

  def subject_for_token(_, _), do: {:error, "Unknown user"}

  def resource_from_claims(%{"sub" => id}), do: {:ok, Accounts.get_user!(id)}

  def resource_from_claims(_), do: {:error, "subject not found"}
end
