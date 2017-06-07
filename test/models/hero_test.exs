defmodule DotaLust.HeroTest do
  use DotaLust.ModelCase

  alias DotaLust.Hero

  @valid_attrs %{avatars: %{}, hero_id: 42, hero_name: "some content", localized_name: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hero.changeset(%Hero{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hero.changeset(%Hero{}, @invalid_attrs)
    refute changeset.valid?
  end
end
