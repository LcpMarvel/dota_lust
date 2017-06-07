defmodule DotaLust.GameItemTest do
  use DotaLust.ModelCase

  alias DotaLust.GameItem

  @valid_attrs %{cost: 42, game_item_id: 42, image: "some content", localized_name: "some content", name: "some content", secret_shop: 42, side_shop: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GameItem.changeset(%GameItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GameItem.changeset(%GameItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
