defmodule DotaLust.Plug.WechatAppletAuthentication do
  import Plug.Conn

  alias DotaLust.WechatAppletUserSession
  alias DotaLust.Repo

  @spec init(any) :: any
  def init(options) do
    options
  end

  @spec call(Plug.Conn.t, any) :: Plug.Conn.t | no_return
  def call(conn, _options) do
    case get_req_header(conn, "token") do
      [] ->
        unauthorized_error(conn)
      [token] ->
        case get_resource(token) do
          nil ->
            unauthorized_error(conn)

          resource ->
            put_private(conn, :wechat_applet_resource, resource)
        end
    end
  end

  @spec get_resource(binary) :: Ecto.Schema.t
  def get_resource(token) do
    WechatAppletUserSession
      |> WechatAppletUserSession.valid
      |> Repo.get_by(token: token)
  end

  @spec unauthorized_error(Plug.Conn.t) :: no_return
  def unauthorized_error(conn) do
    conn
      |> send_resp(401, "unauthorized")
      |> halt
  end
end
