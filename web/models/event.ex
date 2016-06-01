defmodule Pepe.Event do
  use Pepe.Web, :model

  schema "events" do
    field :event_type, :string
    field :twitter_user_id, :integer
    field :tweet_id, :integer
    belongs_to :user, Pepe.User

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event_type, :twitter_user_id, :tweet_id])
    |> validate_required([:event_type, :twitter_user_id])
  end
end
