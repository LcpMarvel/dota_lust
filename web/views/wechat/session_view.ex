defmodule DotaLust.Wechat.SessionView do
  alias DotaLust.SteamAccount

  alias DotaLust.Repo

  def render("create.json", %{user_session: user_session}) do
    steam_accounts_count =
      SteamAccount
        |> SteamAccount.wechat_open_id_scope(user_session.wechat_open_id)
        |> Repo.aggregate(:count, :id)

    %{
      token: user_session.token,
      expired_at: Timex.to_unix(user_session.expired_at),
      steam_id_bound: steam_accounts_count > 0
    }
  end
end
