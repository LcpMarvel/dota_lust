defmodule DotaLust.Wechat.MatchController do
  use DotaLust.Web, :controller

  import DotaLust.ResponseHelper
  import DotaLust.SteamAccountHelper

  alias DotaLust.Match

  plug DotaLust.Plug.WechatAppletAuthentication, user_authentication: true

  def index(conn, %{"account_id" => account_id}) do
    find_and_render_matches(conn, account_id)
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    case default_steam_account(current_user) do
      nil ->
        unprocessable_entity_error(conn)
      account ->
        find_and_render_matches(conn, account.account_id)
    end
  end

  def show(conn, %{"id" => match_id}) do
    match = Repo.get_by!(Match, match_id: match_id)

    render(conn, "show.json", match: match)
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
