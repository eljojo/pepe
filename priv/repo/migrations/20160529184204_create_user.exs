defmodule Pepe.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :twitter_user_id, :bigint, null: false
      add :twitter_access_token, :string
      add :twitter_access_secret, :string

      timestamps
    end
    create index(:users, [:twitter_user_id], unique: true)
  end
end
