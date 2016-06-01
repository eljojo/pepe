defmodule Pepe.TwitterUserTest do
  use Pepe.ModelCase

  alias Pepe.TwitterUser

  @valid_attrs %{avatar: "some content", name: "some content", twitter_user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TwitterUser.changeset(%TwitterUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TwitterUser.changeset(%TwitterUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
