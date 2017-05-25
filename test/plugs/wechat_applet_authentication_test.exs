defmodule DotaLust.WechatAppletAuthenticationTest do
  # use ExUnit.Case, async: true
  # use Plug.Test

  use DotaLust.ConnCase
  import DotaLust.Factory
  alias DotaLust.Plug.WechatAppletAuthentication

  test "returns 401 if token invalid" do
    conn = build_conn(:get, "/hello")

    conn = WechatAppletAuthentication.call(conn, nil)

    assert conn.status == 401
  end

  test "return 200 if token valid" do
    resource = insert(:wechat_applet_user_session)

    conn =
      build_conn(:get, "/hello")
        |> put_req_header("token", resource.token)
        |> WechatAppletAuthentication.call(nil)

    assert conn.status != 401
    assert conn.private[:wechat_applet_resource]
  end
end
