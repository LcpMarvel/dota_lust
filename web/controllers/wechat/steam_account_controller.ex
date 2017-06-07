defmodule DotaLust.Wechat.SteamAccountController do
  use DotaLust.Web, :controller

  alias DotaLust.SteamAccount

  import DotaLust.ResponseHelper

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def create(conn, %{"account_id" => account_id}) do
    account_id = account_id || 275477134

    current_user = conn.assigns.current_user

    steam_account =
      case Repo.get_by(SteamAccount, account_id: account_id, user_id: current_user.id) do
        nil ->
          %SteamAccount{}
            |> SteamAccount.changeset(%{account_id: account_id, user_id: current_user.id})
            |> Repo.insert!

        record ->
          record
      end

    conn |> no_content_json
  end
end
