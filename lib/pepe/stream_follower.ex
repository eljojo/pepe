defmodule Pepe.StreamFollower do
  require Logger
  alias Pepe.Repo
  alias Pepe.Event

  def stream(user) do
    setup_credentials_for_user(user)
    ExTwitter.stream_user
    |> Stream.map(&process_event/1)
    |> Stream.filter(&(!!&1))
    |> Stream.map(&insert_event(&1, user))
    |> Stream.run
  end

  defp insert_event(params, user) do
    event = Ecto.build_assoc(user, :events)
    changeset = Event.changeset(event, params)
    Repo.insert(changeset)
  end

  defp process_event({:event, %{event: event_type} = event}) do
    process_event(event_type, event)
  end

  defp process_event({:delete, event}) do
    Logger.debug("tweet has been deleted: " <> inspect(event))
    nil
  end

  defp process_event(%ExTwitter.Model.Tweet{} = tweet) do
    if tweet.retweeted_status == nil do
      process_event("tweet", tweet)
    else
      process_event("retweet", tweet)
    end
  end

  defp process_event(other) do
    Logger.debug(inspect(other))
    nil
  end

  defp process_event(action, tweet) when action == "tweet" or action == "retweet" do
    Logger.debug(action <> " with id: " <> Integer.to_string(tweet.id) <> " from user with id: " <> Integer.to_string(tweet.user.id))
    %{
      event_type: action,
      related_twitter_user_id: tweet.user.id,
      related_tweet_id: tweet.id
    }
  end

  defp process_event(action, event) when action == "favorite" or action == "unfavorite" do
    user_id = event.source.id
    tweet_id = event.target_object.id
    Logger.debug(action <> ": user id: " <> Integer.to_string(user_id) <> " favorited tweet id: " <> Integer.to_string(tweet_id))
    %{
      event_type: action,
      related_twitter_user_id: user_id,
      related_tweet_id: tweet_id
    }
  end

  # favorited_retweet is triggered after a retweet has been favorited.
  # luckily, a "favorite" event is also triggered, so we can safely ignore
  # this one.
  defp process_event("favorited_retweet", _), do: nil

  defp process_event(type, event) do
    Logger.debug("unhandled event " <> type <> ": " <> inspect(event))
    nil
  end

  defp setup_credentials_for_user(user) do
    app_credentials = Map.new Application.get_env(:extwitter, :oauth, %{})
    user_credentials = %{
      access_token: user.twitter_access_token,
      access_token_secret: user.twitter_access_secret
    }
    ExTwitter.configure(:process, Map.merge(app_credentials, user_credentials))
  end
end
