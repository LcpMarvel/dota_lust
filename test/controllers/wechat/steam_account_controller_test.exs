defmodule DotaLust.Wechat.SteamAccountControllerTest do
  use DotaLust.ConnCase
  import DotaLust.Factory

  alias DotaLust.Repo
  alias DotaLust.SteamAccount
  alias DotaLust.UserSteamAccount

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "#create", %{conn: conn} do
    account_id = "275477134"

    resource = insert(:wechat_applet_user_session)

    use_cassette "create_steam_account" do
      conn
        |> put_req_header("token", resource.token)
        |> post("api/wechat/steam_accounts", %{account_id: account_id})
    end

    steam_account =
      SteamAccount
        |> Repo.get_by(account_id: account_id)

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
      user_steam_account: user_steam_account,
      steam_account: steam_account
    } = setup_data()

    conn
      |> put_req_header("token", resource.token)
      |> delete("api/wechat/steam_accounts/#{steam_account.id}")

    assert Repo.get_by(UserSteamAccount, id: user_steam_account.id) == nil
    assert Repo.get_by(SteamAccount, id: steam_account.id)
  end

  defp setup_data do
    resource = insert(:wechat_applet_user_session) |> Repo.preload(:user)
    steam_account = insert(:steam_account)
    user_steam_account = insert(:user_steam_account, user: resource.user,
                                                     steam_account: steam_account)

    %{
      wechat_applet_user_session: resource,
      user_steam_account: user_steam_account,
      steam_account: steam_account
    }
  end
end
