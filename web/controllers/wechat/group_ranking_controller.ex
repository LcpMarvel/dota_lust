defmodule DotaLust.Wechat.GroupRankingController do
  use DotaLust.Web, :controller

  plug DotaLust.Plug.WechatAppletAuthentication

  def index(conn, _params) do

  end
end
