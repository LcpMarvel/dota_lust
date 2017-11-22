defmodule DotaLust.Wechat.UserGroupController do
  use DotaLust.Web, :controller

  alias DotaLust.UserGroup
  alias DotaLust.WechatAppletUserSession

  plug DotaLust.Plug.WechatAppletAuthentication

  def create(conn, %{"encrypted_data" => encrypted_data, "iv" => iv}) do
    %WechatAppletUserSession{
      wechat_open_id: wechat_open_id
    } = conn.assigns.wechat_applet_resource

    {:ok, group_id} = decode_data(wechat_open_id, encrypted_data, iv)

    user_group =
      case Repo.get_by(UserGroup, wechat_open_id: wechat_open_id, group_id: group_id) do
        nil ->
          %UserGroup{}
            |> UserGroup.changeset(%{wechat_open_id: wechat_open_id, group_id: group_id})
            |> Repo.insert!
        record ->
          record
      end

    render(conn, "create.json", %{user_group: user_group})
  end

  @spec decode_data(binary, binary, binary) :: {:ok, map, binary}
  defp decode_data(wechat_open_id, encrypted_data, iv) do
    %{
      "openGId" => group_id
    } = WechatAppletUserSession
          |> WechatAppletUserSession.by_wechat_open_id(wechat_open_id)
          |> WechatAppletUserSession.valid
          |> Repo.all
          |> Enum.map(
            fn(%WechatAppletUserSession{session_key: session_key}) ->
              try do
                WechatApplet.user_data_decode(encrypted_data, session_key, iv)
              rescue
                _ -> false
              end
            end
          )
          |> Enum.filter(&(&1))
          |> List.first

    {:ok, group_id}
  end
end
