defmodule Pepe.FollowingTest do
  use Pepe.ModelCase

  alias Pepe.Following

  @valid_attrs %{following: true, twitter_user_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Following.changeset(%Following{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Following.changeset(%Following{}, @invalid_attrs)
    refute changeset.valid?
  end
end
