defmodule DotaLust.Wechat.SteamAccountController do
  use DotaLust.Web, :controller

  alias DotaLust.SteamAccount
  alias DotaLust.Worker.Dota2API.FetchRecentWorker
  alias DotaLust.Worker.Dota2API.FetchAccountInfoWorker

  import DotaLust.ResponseHelper

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def create(conn, %{"account_id" => account_id}) do
    current_user = conn.assigns.current_user

    case Repo.get_by(SteamAccount, account_id: account_id, user_id: current_user.id) do
      nil ->
        params = %{
          account_id: account_id,
          user_id: current_user.id,
          default: default_account(current_user.id)
        }

        %SteamAccount{}
          |> SteamAccount.changeset(params)
          |> Repo.insert!
      record ->
        record
    end

    Exq.enqueue(Exq, "dota2_api", FetchRecentWorker, [account_id])
    Exq.enqueue(Exq, "dota2_api", FetchAccountInfoWorker, [account_id])

    conn |> no_content_json
  end

  @spec default_account(integer) :: boolean
  def default_account(user_id) do
    steam_accounts_count =
      SteamAccount
        |> SteamAccount.user_id_scope(user_id)
        |> Repo.aggregate(:count, :id)

    case steam_accounts_count do
      0 -> true
      _ -> false
    end
  end
end
