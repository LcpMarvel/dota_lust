defmodule DotaLust.ItemTest do
  use DotaLust.ModelCase

  alias DotaLust.Item

  @valid_attrs %{game_item_id: 42, player_id: 42, position: 42, place: :wearing}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
