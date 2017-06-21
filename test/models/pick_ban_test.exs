defmodule DotaLust.PickBanTest do
  use DotaLust.ModelCase

  alias DotaLust.PickBan

  @valid_attrs %{hero_id: 42, is_pick: true, match_id: "some content", order: 42, team: :dire}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PickBan.changeset(%PickBan{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PickBan.changeset(%PickBan{}, @invalid_attrs)
    refute changeset.valid?
  end
end
