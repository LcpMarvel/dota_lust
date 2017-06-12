defmodule DotaLust.AbilityUpgradeTest do
  use DotaLust.ModelCase

  alias DotaLust.AbilityUpgrade

  @valid_attrs %{ability_id: 42, level: 42, player_id: 42, upgraded_at: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AbilityUpgrade.changeset(%AbilityUpgrade{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AbilityUpgrade.changeset(%AbilityUpgrade{}, @invalid_attrs)
    refute changeset.valid?
  end
end
