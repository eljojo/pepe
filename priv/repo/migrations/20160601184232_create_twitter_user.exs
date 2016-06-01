defmodule Pepe.Repo.Migrations.CreateTwitterUser do
  use Ecto.Migration

  def change do
    create table(:twitter_users) do
      add :twitter_user_id, :bigint, null: false
      add :name, :string, null: false
      add :avatar, :string

      timestamps
    end

    create index(:twitter_users, [:twitter_user_id], unique: true)
  end
end
