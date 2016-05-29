defmodule Pepe.User do
  use Pepe.Web, :model

  schema "users" do
    field :twitter_user_id, :integer
    field :twitter_access_token, :string
    field :twitter_access_secret, :string
    has_many :events, Pepe.Event

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:twitter_user_id, :twitter_access_token, :twitter_access_secret])
    |> validate_required([:twitter_user_id, :twitter_access_token, :twitter_access_secret])
  end
end
