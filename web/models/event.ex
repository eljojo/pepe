defmodule Pepe.Event do
  use Pepe.Web, :model

  schema "events" do
    field :event_type, :string
    field :tweet_id, :integer
    belongs_to :user, Pepe.User
    belongs_to :twitter_user, Pepe.TwitterUser

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

  def tweet_count_by_twitter_user(query) do
    from e in query,
      left_join: tw in Pepe.TwitterUser, on: e.twitter_user_id == tw.id,
      select: %{count: count(tw.id), twitter_user: tw},
      where: e.event_type == "tweet" or e.event_type == "retweet",
      group_by: tw.id,
      order_by: [desc: :count]
  end

  def only_following_twitter_users(query) do
    from e in query,
      join: fw in Pepe.Following,
      on: e.twitter_user_id == fw.twitter_user_id and e.user_id == fw.user_id,
      where: fw.following == true
  end

  def for_user(query, %Pepe.User{id: id}) do
    for_user(query, id)
  end

  def for_user(query, user_id) when is_integer(user_id) do
    query |> where([e], e.user_id == ^user_id)
  end
end
