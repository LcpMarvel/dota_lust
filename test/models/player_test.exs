defmodule DotaLust.PlayerTest do
  use DotaLust.ModelCase

  alias DotaLust.Player

  @valid_attrs %{account_id: "42", assists_count: 42, deaths_count: 42, denies_count: 42, kda: 12.5, experience_per_minute: 42, gold: 42, gold_per_minute: 42, gold_spent: 42, hero_damage: 42, hero_healing: 42, hero_id: 42, last_hits_count: 42, leaver_status: :none, level: 42, match_id: "some content", kills_count: 42, tower_damage: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
