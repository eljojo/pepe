defmodule Pepe.Repo.Migrations.CreateTwitterUser do
  use Ecto.Migration

  def change do
    create table(:twitter_users, primary_key: false) do
      add :id, :bigint, null: false, primary_key: true
      add :name, :string, null: false
      add :screen_name, :string, null: false
      add :avatar, :string

      timestamps
    end

    create index(:twitter_users, [:id], unique: true)
  end
end
