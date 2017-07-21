defmodule DotaLust.Wechat.SteamAccountControllerTest do
  use DotaLust.ConnCase
  import DotaLust.Factory

  alias DotaLust.Repo
  alias DotaLust.SteamAccount

  test "#create", %{conn: conn} do
    account_id = "105248644"

    resource = insert(:wechat_applet_user_session)

    conn
      |> put_req_header("token", resource.token)
      |> post("api/wechat/steam_accounts", %{account_id: account_id})

    steam_account =
      SteamAccount
        |> Repo.get_by(user_id: resource.user_id, account_id: account_id)

    assert steam_account
  end

  test "#create invalid account", %{conn: conn} do
    resource = insert(:wechat_applet_user_session)

    result =
      conn
        |> put_req_header("token", resource.token)
        |> post("api/wechat/steam_accounts", %{account_id: ""})
        |> response(422)

    assert result =~ "无法从该帐号中获取数据"
  end

  test "#index", %{conn: conn} do
    %{wechat_applet_user_session: resource} = setup_data()

    steam_accounts =
      conn
        |> put_req_header("token", resource.token)
        |> get("api/wechat/steam_accounts")
        |> json_response(200)

    assert Enum.count(steam_accounts) > 0
  end

  test "#delete", %{conn: conn} do
    %{
      wechat_applet_user_session: resource,
      steam_account: steam_account
    } = setup_data()

    conn
      |> put_req_header("token", resource.token)
      |> delete("api/wechat/steam_accounts/#{steam_account.id}")

    assert Repo.get_by(SteamAccount, id: steam_account.id) == nil
  end

  defp setup_data do
    resource = insert(:wechat_applet_user_session) |> Repo.preload(:user)
    steam_account = insert(:steam_account, user: resource.user)

    %{
      wechat_applet_user_session: resource,
      steam_account: steam_account
    }
  end
end
