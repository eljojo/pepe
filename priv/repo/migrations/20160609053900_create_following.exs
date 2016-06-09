defmodule Pepe.Repo.Migrations.CreateFollowing do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :twitter_user_id, :bigint, null: false
      add :following, :boolean, default: true, null: false

      timestamps
    end
    create index(:followings, [:user_id, :twitter_user_id], unique: true)
  end
end
