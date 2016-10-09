defmodule Pepe.PageController do
  use Pepe.Web, :controller
  alias Pepe.Event
  alias Pepe.User

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"user_id" => user_id} = params) do
    user = Repo.get(User, user_id)
    tweet_counts = Event
                    |> Event.for_user(user)
                    |> Event.only_following_twitter_users
                    |> Event.tweet_count_by_twitter_user
                    |> Repo.all
    mode = case params["mode"] do
      "list" -> :list
      _ -> :grid
    end
    render conn, "show.html", tweet_counts: tweet_counts, mode: mode
  end
end
