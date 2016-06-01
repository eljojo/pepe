defmodule Pepe.Repo.Migrations.RemoveRelatedFromEventTwitterColumns do
  use Ecto.Migration

  def change do
    rename table(:events), :related_twitter_user_id, to: :twitter_user_id
    rename table(:events), :related_tweet_id, to: :tweet_id
  end
end
