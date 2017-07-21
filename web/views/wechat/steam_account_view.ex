defmodule DotaLust.Wechat.SteamAccountView do
  def render("index.json", %{steam_accounts: steam_accounts}) do
    steam_accounts
      |> Enum.map(&steam_account_json/1)
  end

  def render("create.json", %{steam_account: steam_account}) do
    steam_account_json(steam_account)
  end

  def render("summary.json", %{steam_account: steam_account, summary: summary}) do
    %{
      id: steam_account.id,
      account_id: steam_account.account_id,
      display_name: steam_account.display_name,
      avatars: steam_account.avatars,
      created_at: steam_account.created_at,
      default: steam_account.default,
      valid: steam_account.valid,
      summary: summary
    }
  end

  defp steam_account_json(steam_account) do
    %{
      id: steam_account.id,
      account_id: steam_account.account_id,
      display_name: steam_account.display_name,
      avatars: steam_account.avatars,
      default: steam_account.default,
      valid: steam_account.valid
    }
  end
end
