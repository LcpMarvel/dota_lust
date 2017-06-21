defmodule DotaLust.Wechat.MatchController do
  use DotaLust.Web, :controller

  import DotaLust.ResponseHelper

  alias DotaLust.SteamAccount
  alias DotaLust.Match

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def index(conn, %{"account_id" => account_id}) do
    find_and_render_matches(conn, account_id)
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    steam_account =
      SteamAccount
        |> SteamAccount.default_record(current_user.id)
        |> Repo.one

    case steam_account do
      nil ->
        unprocessable_entity_error(conn)
      account ->
        find_and_render_matches(conn, account.account_id)
    end
  end

  defp find_and_render_matches(conn, nil) do
    unprocessable_entity_error(conn)
  end

  defp find_and_render_matches(conn, account_id) do
    matches =
      Match
        |> Match.account_id_scope(account_id)
        |> Match.recent
        |> Repo.all

    render(conn, "index.json", matches: matches)
  end
end
