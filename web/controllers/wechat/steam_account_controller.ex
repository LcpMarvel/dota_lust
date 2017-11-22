defmodule DotaLust.Wechat.SteamAccountController do
  use DotaLust.Web, :controller

  alias DotaLust.SteamAccount
  alias DotaLust.UserSteamAccount
  alias DotaLust.Worker.Dota2API.FetchRecentWorker
  alias DotaLust.Worker.Dota2API.FetchAccountInfoWorker

  import DotaLust.ResponseHelper
  import DotaLust.UserSteamAccountHelper

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def index(conn, _params) do
    user =
      conn.assigns.current_user
        |> Repo.preload(users_steam_accounts: :steam_account)

    render(conn, "index.json", users_steam_accounts: user.users_steam_accounts)
  end

  def create(conn, %{"account_id" => account_id}) do
    case SteamId.lookup(account_id) do
      %SteamId{steam_id3: steam_id} ->
        current_user = conn.assigns.current_user

        [[id]] = Regex.scan(~r/\d{3,}/, steam_id)
        steam_account = find_or_create_steam_account_by_account_id(id)

        unless has_bound_steam_account?(current_user, steam_account) do
          params = %{
            steam_account_id: steam_account.id,
            user_id: current_user.id,
            default: as_default_account?(current_user.id)
          }

          %UserSteamAccount{}
            |> UserSteamAccount.changeset(params)
            |> Repo.insert!
        end

        delegate_to_workers(steam_account)

        render(conn, "create.json", steam_account: steam_account)
      :not_found ->
        unprocessable_entity_error(conn, "无法从该帐号中获取数据")
    end
  end

  def delete(conn, %{"id" => id}) do
    user_steam_account =
      conn.assigns.current_user
        |> current_user_steam_account(id)

    user_steam_account |> Repo.delete!

    if user_steam_account.default do
      next_defalut_steam_account =
        UserSteamAccount
          |> Repo.get_by(user_id: conn.assigns.current_user.id)

      if next_defalut_steam_account do
        next_defalut_steam_account |> to_default_steam_account
      end
    end

    conn |> no_content_json
  end

  def default(conn, %{"steam_account_id" => id}) do
    current_user = conn.assigns.current_user

    UserSteamAccount
      |> UserSteamAccount.user_id_scope(current_user.id)
      |> Repo.update_all(set: [default: false])

    current_user
      |> current_user_steam_account(id)
      |> to_default_steam_account

    conn |> no_content_json
  end

  def summary(conn, params) do
    user_steam_account =
      conn.assigns.current_user
        |> current_user_steam_account(params["steam_account_id"])

    summary = DotaLust.Analysis.Match.recent_matches_summary(
      user_steam_account.steam_account.account_id
    )

    render(conn, "summary.json", user_steam_account: user_steam_account,
                                 summary: summary)
  end

  def refresh(conn, %{"steam_account_id" => id}) do
    user_steam_account =
      conn.assigns.current_user
        |> current_user_steam_account(id)

    delegate_to_workers(user_steam_account.steam_account)

    conn |> no_content_json
  end

  @spec as_default_account?(integer) :: boolean
  defp as_default_account?(user_id) do
    steam_accounts_count =
      UserSteamAccount
        |> UserSteamAccount.user_id_scope(user_id)
        |> Repo.aggregate(:count, :id)

    steam_accounts_count == 0
  end

  def current_user_steam_account(current_user, steam_account_id) do
    case steam_account_id do
      nil ->
        default_user_steam_account(current_user)
      id ->
        UserSteamAccount
          |> UserSteamAccount.user_id_scope(current_user.id)
          |> Repo.get_by!(steam_account_id: id)
          |> Repo.preload(:steam_account)
    end
  end

  defp find_or_create_steam_account_by_account_id(account_id) do
    case Repo.get_by(SteamAccount, account_id: account_id) do
      nil ->
        %SteamAccount{}
          |> SteamAccount.changeset(%{account_id: account_id})
          |> Repo.insert!
      steam_account ->
        steam_account
    end
  end

  defp has_bound_steam_account?(current_user, steam_account) do
    Repo.get_by(
      UserSteamAccount, steam_account_id: steam_account.id,
                        user_id: current_user.id
    )
  end

  defp to_default_steam_account(user_steam_account) do
    user_steam_account
      |> Ecto.Changeset.change(default: true)
      |> Repo.update!
  end

  defp delegate_to_workers(steam_account) do
    account_id = steam_account.account_id

    Exq.enqueue(Exq, "dota2_api", FetchRecentWorker, [steam_account.id, account_id])
    Exq.enqueue(Exq, "dota2_api", FetchAccountInfoWorker, [account_id])
  end
end
