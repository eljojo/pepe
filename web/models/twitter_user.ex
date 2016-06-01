defmodule Pepe.TwitterUser do
  use Pepe.Web, :model

  schema "twitter_users" do
    field :twitter_user_id, :integer
    field :name, :string
    field :avatar, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:twitter_user_id, :name, :avatar])
    |> validate_required([:twitter_user_id, :name])
  end
end
