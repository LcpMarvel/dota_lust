defmodule DotaLust.SteamAccountHelper do
  alias DotaLust.Repo

  alias DotaLust.SteamAccount

  def default_steam_account(user) do
    SteamAccount
      |> SteamAccount.default_record(user.id)
      |> Repo.one
  end
end
