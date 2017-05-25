defmodule DotaLust.Wechat.UserController do
  use DotaLust.Web, :controller

  alias DotaLust.Repo
  alias DotaLust.User
  alias DotaLust.WechatAppletUserSession

  plug DotaLust.Plug.WechatAppletAuthentication

  def update(conn, %{"encrypted_data" => encrypted_data, "iv" => iv,
    "raw_data" => raw_data, "signature" => signature}) do
    %WechatAppletUserSession{session_key: session_key} = conn.private[:wechat_applet_resource]

    case WechatApplet.user_data_verify(raw_data, session_key, signature) do
      true ->
        {:ok, params, appid} = decode_data(encrypted_data, session_key, iv)

        case Application.fetch_env!(:dota_lust, :wechat_app_id) == appid do
          true ->
            User.insert_or_update_by_wechat_open_id!(params[:wechat_open_id], params)

            conn
              |> put_resp_header("content-type", "application/json")
              |> send_resp(204, "")
          false ->
            conn
              |> send_resp(401, "The appid is incorrect!")
        end
      false ->
        conn
          |> send_resp(401, "The dota is incorrect!")
    end
  end

  @spec decode_data(binary, binary, binary) :: {:ok, map, binary}
  defp decode_data(encrypted_data, session_key, iv) do
    %{
      "avatarUrl" => avatar_url,
      "city" => city,
      "country" => country,
      "gender" => gender,
      "language" => language,
      "nickName" => nick_name,
      "openId" => wechat_open_id,
      "province" => province,
      "watermark" => %{
        "appid" => appid
      }
    } = WechatApplet.user_data_decode(encrypted_data, session_key, iv)

    params = %{
      nick_name: nick_name,
      wechat_open_id: wechat_open_id,
      gender: gender == 1,
      language: language,
      avatar_url: avatar_url,
      country: country,
      province: province,
      city: city
    }

    {:ok, params, appid}
  end
end