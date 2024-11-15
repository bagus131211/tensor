defmodule Graphical.Repo.Migrations.AddHashPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_hash, :string
    end
  end
end
