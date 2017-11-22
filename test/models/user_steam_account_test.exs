defmodule DotaLust.UserSteamAccountTest do
  use DotaLust.ModelCase

  alias DotaLust.UserSteamAccount

  @valid_attrs %{steam_account_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserSteamAccount.changeset(%UserSteamAccount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserSteamAccount.changeset(%UserSteamAccount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
