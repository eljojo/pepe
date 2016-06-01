defmodule Pepe.TwitterUser do
  use Pepe.Web, :model

  schema "twitter_users" do
    field :screen_name, :string
    field :name, :string
    field :avatar, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:screen_name, :name, :avatar])
    |> validate_required([:screen_name, :name])
  end
end
