defmodule DotaLust.UserSteamAccountHelper do
  alias DotaLust.Repo

  alias DotaLust.UserSteamAccount

  def default_user_steam_account(user) do
    UserSteamAccount
      |> UserSteamAccount.default_record(user.id)
      |> Repo.one!
      |> Repo.preload(:steam_account)
  end
end
