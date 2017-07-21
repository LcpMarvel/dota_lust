defmodule DotaLust.WechatAppletAuthenticationTest do
  use DotaLust.ConnCase

  import DotaLust.Factory
  alias DotaLust.Plug.WechatAppletAuthentication

  test "returns 401 if token invalid" do
    conn = build_conn(:get, "/hello")

    conn = WechatAppletAuthentication.call(conn, nil)

    assert conn.status == 401
  end

  test "returns 401 if user is empty and has user_authentication option" do
    resource =
      insert(:wechat_applet_user_session, user: nil)

    conn = call_plug(resource.token)

    assert conn.status == 401
  end

  test "return 200 if token valid" do
    resource = insert(:wechat_applet_user_session)

    conn = call_plug(resource.token)

    assert conn.status != 401
    assert conn.assigns[:wechat_applet_resource]
  end

  def call_plug(token) do
    build_conn(:get, "/hello")
      |> put_req_header("token", token)
      |> WechatAppletAuthentication.call(user_authentication: true)
  end
end
