defmodule Pepe.Following do
  use Pepe.Web, :model

  schema "followings" do
    belongs_to :user, Pepe.User
    belongs_to :twitter_user, Pepe.TwitterUser
    field :following, :boolean, default: false

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :twitter_user_id, :following])
    |> validate_required([:user_id, :twitter_user_id])
  end

  def where_following(following), do: where_following(Pepe.Following, following)
  def where_following(query, following) do
    query |> where([f], f.following == ^following)
  end

  def for_user(user), do: for_user(Pepe.Following, user)
  def for_user(query, %Pepe.User{id: user_id}), do: for_user(query, user_id)
  def for_user(query, user_id) when is_integer(user_id) do
    query |> where([f], f.user_id == ^user_id)
  end

  def for_twitter_user(twitter_user) do
    for_twitter_user(Pepe.Following, twitter_user)
  end
  def for_twitter_user(query, %Pepe.TwitterUser{id: twitter_user_id}) do
    for_twitter_user(query, twitter_user_id)
  end
  def for_twitter_user(query, twitter_user_id) when is_integer(twitter_user_id) do
    query |> where([f], f.twitter_user_id == ^twitter_user_id)
  end

  def twitter_user_ids_for_user(user) do
    twitter_user_ids_for_user(Pepe.Following, user)
  end
  def twitter_user_ids_for_user(query, user) do
    for_user(query, user) |> select([f], f.twitter_user_id)
  end
end
