defmodule Pepe.StreamFollower do
  require Logger
  alias Pepe.Repo
  alias Pepe.Event
  alias Pepe.TwitterUser
  alias Pepe.Following
  alias Pepe.User

  def stream(user) do
    setup_credentials_for_user(user)
    ExTwitter.stream_user([receive_messages: true], :infinity)
    |> Stream.map(&process_event/1)
    |> Stream.each(&insert_twitter_user/1)
    |> Stream.each(&update_followings(&1, user))
    |> Stream.each(&insert_event(&1, user))
    |> Stream.run
  end

  defp insert_event(%{event_type: _} = params, user) do
    event = Ecto.build_assoc(user, :events)
    changeset = Event.changeset(event, params)
    Repo.insert(changeset)
  end

  defp insert_event(_, _), do: nil

  defp insert_twitter_user(%{twitter_user_id: id, twitter_user: changes}) do
    case Repo.get(TwitterUser, id) do
      nil  -> %TwitterUser{id: id}
      twitter_user -> twitter_user
    end
    |> TwitterUser.changeset(changes)
    |> Repo.insert_or_update
  end

  defp insert_twitter_user(_), do: {:error, "no user details"}

  defp update_followings(%{friends: friends}, user) do
    query = Following.twitter_user_ids_for_user(user) |> Following.where_following(true)
    existing_followings = query |> Repo.all

    new_follows = friends -- existing_followings
    Logger.info("new follows: " <> inspect(new_follows))
    insert_followings(new_follows, true, user)

    unfollows = existing_followings -- friends
    Logger.info("unfollows: " <> inspect(unfollows))
    insert_followings(unfollows, false, user)
  end

  defp update_followings(%{twitter_user_id: tw_id}, %User{twitter_user_id: tw_id}) do
    nil
  end
  defp update_followings(%{event_type: "follow", twitter_user_id: friend}, user) do
    insert_following(friend, true, user)
  end
  defp update_followings(%{event_type: "unfollow", twitter_user_id: friend}, user) do
    insert_following(friend, false, user)
  end
  defp update_followings(_, _), do: nil

  defp insert_followings([friend | rest], is_following, user) do
    insert_following(friend, is_following, user)
    insert_followings(rest, is_following, user)
  end
  defp insert_followings([], _, _), do: nil

  defp insert_following(friend, is_following, user) do
    query = Following.for_user(user) |> Following.for_twitter_user(friend)
    case Repo.one(query) do
      nil  -> %Following{user_id: user.id, twitter_user_id: friend}
      following -> following
    end
    |> Following.changeset(%{following: is_following})
    |> Repo.insert_or_update
  end

  defp process_event({_, %{event: event_type} = event}) when is_bitstring(event_type) do
    process_event(event_type, event)
  end

  defp process_event(%ExTwitter.Model.Tweet{} = tweet) do
    if tweet.retweeted_status == nil do
      process_event("tweet", tweet)
    else
      process_event("retweet", tweet)
    end
  end

  defp process_event(%ExTwitter.Model.DeletedTweet{status: tweet}) do
    Logger.info("deleted tweet with id: " <> Integer.to_string(tweet.id) <> " from user with id: " <> Integer.to_string(tweet.user_id))
    %{
      event_type: "delete_tweet",
      twitter_user_id: tweet.user_id,
      tweet_id: tweet.id
    }
  end

  defp process_event({:friends, %{friends: friends}}) do
    %{friends: friends}
  end

  defp process_event(other) do
    Logger.warn("unhandled message: " <> inspect(other))
  end

  defp process_event(action, tweet) when action == "tweet" or action == "retweet" do
    Logger.info(action <> " with id: " <> Integer.to_string(tweet.id) <> " from user: @" <> tweet.user.screen_name <> " (id: " <> Integer.to_string(tweet.user.id) <> ")")
    %{
      event_type: action,
      twitter_user_id: tweet.user.id,
      tweet_id: tweet.id,
      twitter_user: parse_twitter_user(tweet.user)
    }
  end

  defp process_event(type, event) when type == "follow" or type == "unfollow"  do
    user = event.target
    Logger.info(type <> ": user @" <> user.screen_name <> " (id: " <> Integer.to_string(user.id) <> ")")
    %{
      event_type: type,
      twitter_user_id: user.id,
      twitter_user: parse_twitter_user(user)
    }
  end

  defp process_event(action, event) when action == "favorite" or action == "unfavorite" do
    user_id = event.source.id
    tweet_id = event.target_object.id
    Logger.info(action <> ": user @" <> event.source.screen_name <> " (id: " <> Integer.to_string(user_id) <> ") favorited tweet id: " <> Integer.to_string(tweet_id))
    %{
      event_type: action,
      twitter_user_id: user_id,
      tweet_id: tweet_id,
      twitter_user: parse_twitter_user(event.source)
    }
  end

  # favorited_retweet is triggered after a retweet has been favorited.
  # luckily, a "favorite" event is also triggered, so we can safely ignore
  # this one.
  defp process_event("favorited_retweet", _), do: nil
  defp process_event("quoted_tweet", _), do: nil
  defp process_event("retweeted_retweet", _), do: nil

  defp process_event(type, event) do
    Logger.warn("unhandled event " <> type <> ": " <> inspect(event))
  end

  defp setup_credentials_for_user(user) do
    app_credentials = Map.new Application.get_env(:extwitter, :oauth, %{})
    user_credentials = %{
      access_token: user.twitter_access_token,
      access_token_secret: user.twitter_access_secret
    }
    ExTwitter.configure(:process, Map.merge(app_credentials, user_credentials))
  end

  defp parse_twitter_user(user) do
    %{
      screen_name: user.screen_name,
      name: user.name,
      avatar: user.profile_image_url_https
    }
  end
end
