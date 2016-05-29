defmodule Pepe.UserTest do
  use Pepe.ModelCase

  alias Pepe.User

  @valid_attrs %{twitter_access_secret: "some content", twitter_access_token: "some content", twitter_user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
