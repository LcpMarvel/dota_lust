defmodule DotaLust.Wechat.SessionView do
  alias DotaLust.SteamAccount

  def render("create.json", %{user_session: user_session,
                              steam_accounts_count: steam_accounts_count}) do
    %{
      token: user_session.token,
      expired_at: Timex.to_unix(user_session.expired_at),
      steam_id_bound: steam_accounts_count > 0
    }
  end
end
