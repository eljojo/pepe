defmodule Pepe.Event do
  use Pepe.Web, :model

  schema "events" do
    field :event_type, :string
    field :related_twitter_user_id, :integer
    field :related_tweet_id, :integer
    belongs_to :user, Pepe.User

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event_type, :related_twitter_user_id, :related_tweet_id, :inserted_at])
    |> validate_required([:event_type, :related_twitter_user_id, :inserted_at])
  end
end
