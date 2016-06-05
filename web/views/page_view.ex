defmodule Pepe.PageView do
  use Pepe.Web, :view

  def sum_counts(tweet_counts) do
    tweet_counts |> Enum.map(&(&1.count)) |> Enum.sum
  end

  def tweet_count_image(tweet_count, sum) do
    percentage = tweet_count.count / sum
    twitter_user = tweet_count.twitter_user
    display_size = 3000 * percentage
    options = [
      src: twitter_user.avatar,
      title: "@#{twitter_user.screen_name}: #{Float.round(percentage * 100, 2)}%",
      style: "width: #{display_size}px; height: #{display_size}px",
      target: "_blank"
    ]
    content_tag(:img, "", options)
  end
end
