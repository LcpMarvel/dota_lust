defmodule DotaLust.Wechat.SteamAccountController do
  use DotaLust.Web, :controller

  alias DotaLust.SteamAccount
  alias DotaLust.Worker.Dota2API.FetchRecentWorker
  alias DotaLust.Worker.Dota2API.FetchAccountInfoWorker

  alias Dota2API.Mapper.Matches, as: Dota2MatchesAPI

  import DotaLust.ResponseHelper

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    steam_accounts =
      SteamAccount
        |> SteamAccount.user_id_scope(current_user.id)
        |> Repo.all

    render(conn, "index.json", steam_accounts: steam_accounts)
  end

  def account_valid?(account_id) when length(account_id) == 0 do
    true
  end
  def account_valid?(account_id) do
    case Dota2MatchesAPI.load(account_id: account_id, matches_requested: 1) do
      {:ok, _, _, _, _} -> false
      {:error, _} -> true
    end
  end

  def create(conn, %{"account_id" => account_id}) do
    case account_valid?(account_id) do
      true ->
        current_user = conn.assigns.current_user

        steam_account =
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

        delegate_to_workers(steam_account)

        render(conn, "create.json", steam_account: steam_account)
      false ->
        unprocessable_entity_error(conn, "无法从该帐号中获取数据")
    end
  end

  def delete(conn, %{"id" => id}) do
    steam_account = current_steam_account(conn.assigns.current_user, id)

    if steam_account.default do
      next_defalut_steam_account =
        SteamAccount
          |> SteamAccount.user_id_scope(conn.assigns.current_user.id, 1)
          |> Repo.one

      if next_defalut_steam_account do
        next_defalut_steam_account |> to_default_steam_account
      end
    end

    steam_account |> Repo.delete!

    conn |> no_content_json
  end

  def default(conn, %{"steam_account_id" => id}) do
    current_user = conn.assigns.current_user

    SteamAccount
      |> SteamAccount.user_id_scope(current_user.id)
      |> Repo.update_all(set: [default: false])

    current_steam_account(current_user, id) |> to_default_steam_account

    conn |> no_content_json
  end

  def summary(conn, params) do
    steam_account =
      conn.assigns.current_user
        |> current_steam_account(params["steam_account_id"])

    summary = DotaLust.Analysis.Match.recent_matches_summary(steam_account.account_id)

    render(conn, "summary.json", steam_account: steam_account, summary: summary)
  end

  def refresh(conn, %{"steam_account_id" => id}) do
    conn.assigns.current_user
      |> current_steam_account(id)
      |> delegate_to_workers

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

  def current_steam_account(current_user, steam_account_id) do
    case steam_account_id do
      nil ->
        SteamAccount
          |> SteamAccount.default_record(current_user.id)
          |> Repo.one!
      id ->
        SteamAccount
          |> SteamAccount.user_id_scope(current_user.id)
          |> Repo.get_by!(id: id)
    end
  end

  defp to_default_steam_account(steam_account) do
    steam_account
      |> Ecto.Changeset.change(default: true)
      |> Repo.update
  end

  defp delegate_to_workers(steam_account) do
    account_id = steam_account.account_id

    Exq.enqueue(Exq, "dota2_api", FetchRecentWorker, [steam_account.id, account_id])
    Exq.enqueue(Exq, "dota2_api", FetchAccountInfoWorker, [account_id])
  end
end
