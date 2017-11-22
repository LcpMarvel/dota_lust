defmodule DotaLust.Wechat.SteamAccountView do
  def render("index.json", %{users_steam_accounts: users_steam_accounts}) do
    users_steam_accounts
      |> Enum.map(&steam_account_json/1)
  end

  def render("create.json", %{steam_account: steam_account}) do
    %{
      id: steam_account.id,
      account_id: steam_account.account_id,
      display_name: steam_account.display_name,
      avatars: steam_account.avatars,
      valid: steam_account.valid
    }
  end

  def render("summary.json", %{user_steam_account: user_steam_account, summary: summary}) do
    steam_account = user_steam_account.steam_account

    %{
      id: steam_account.id,
      account_id: steam_account.account_id,
      display_name: steam_account.display_name,
      avatars: steam_account.avatars,
      created_at: steam_account.created_at,
      default: user_steam_account.default,
      valid: steam_account.valid,
      summary: summary
    }
  end

  defp steam_account_json(user_steam_account) do
    steam_account = user_steam_account.steam_account

    %{
      id: steam_account.id,
      account_id: steam_account.account_id,
      display_name: steam_account.display_name,
      avatars: steam_account.avatars,
      default: user_steam_account.default,
      valid: steam_account.valid
    }
  end
end
