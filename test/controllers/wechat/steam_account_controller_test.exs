defmodule DotaLust.Wechat.SteamAccountControllerTest do
  use DotaLust.ConnCase
  import DotaLust.Factory

  alias DotaLust.Repo
  alias DotaLust.SteamAccount

  test "#create", %{conn: conn} do
    account_id = "275477134"

    resource = insert(:wechat_applet_user_session)

    conn
      |> put_req_header("token", resource.token)
      |> post("api/wechat/steam_accounts", %{account_id: account_id})

    steam_account =
      SteamAccount
        |> Repo.get_by(user_id: resource.user_id, account_id: account_id)

    assert steam_account
  end
end
