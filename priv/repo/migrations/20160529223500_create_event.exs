defmodule Pepe.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :event_type, :string, null: false
      add :related_twitter_user_id, :bigint
      add :related_tweet_id, :bigint
      add :inserted_at, :datetime, null: false
    end
    create index(:events, [:user_id, :event_type])
  end
end
