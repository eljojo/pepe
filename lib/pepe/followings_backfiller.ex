defmodule Pepe.FollowingsBackfiller do
  require Logger
  alias Pepe.TwitterUser
  alias Pepe.Following
  alias Pepe.Repo

  def process(user) do
    setup_credentials_for_user(user)

    twitter_user_ids = Following.without_user_data(Following.for_user(user))
    |> Repo.all
    |> Enum.map(fn(following) -> following.twitter_user_id end)
    |> get_and_persist_info_for_users
  end

  defp get_and_persist_info_for_users(twitter_user_ids) when length(twitter_user_ids) > 100 do
    {first_list, second_list} = twitter_user_ids |> Enum.split(100)
    get_and_persist_info_for_users(first_list) ++ get_and_persist_info_for_users(second_list)
  end

  defp get_and_persist_info_for_users(twitter_user_ids) when length(twitter_user_ids) > 0 do
    options = [
      user_id: twitter_user_ids |> Enum.join(",")
    ]
    ExTwitter.API.Users.user_lookup(options)
    |> Enum.each(&insert_twitter_user(convert_user_to_event(&1)))
  end

  defp get_and_persist_info_for_users(_), do: []

  defp convert_user_to_event(twitter_user) do
    %{
      twitter_user_id: twitter_user.id,
      twitter_user: parse_twitter_user(twitter_user)
   }
  end

  defp insert_twitter_user(%{twitter_user_id: id, twitter_user: changes}) do
    case Repo.get(TwitterUser, id) do
      nil  -> %TwitterUser{id: id}
      twitter_user -> twitter_user
    end
    |> TwitterUser.changeset(changes)
    |> Repo.insert_or_update
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
