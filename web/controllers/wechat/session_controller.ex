defmodule DotaLust.Wechat.SessionController do
  use DotaLust.Web, :controller

  alias DotaLust.WechatAppletUserSession

  @wechat_jscode2session_url "https://api.weixin.qq.com/sns/jscode2session"

  def create(conn, %{"code" => code}) do
    options = [
      params: [
        appid: Application.fetch_env!(:dota_lust, :wechat_app_id),
        secret: Application.fetch_env!(:dota_lust, :wechat_secret),
        js_code: code,
        grant_type: "authorization_code"
      ]
    ]

    {:ok, response} = HTTPoison.get(@wechat_jscode2session_url, [], options)

    user_session = Poison.decode!(response.body)
                     |> WechatAppletUserSession.build_params
                     |> Repo.insert!

    render(conn, "create.json", token: user_session.token)
  end
end
