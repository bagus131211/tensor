defmodule GraphicalWeb.Schema.Types do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :posts, list_of(:post), resolve: dataloader(:db)
  end

  object :post do
    field :id, :id
    field :title, :string
    field :body, :string

    field :user, :user, resolve: dataloader(:db)
  end

  object :session do
    field :token, :string
  end
end
