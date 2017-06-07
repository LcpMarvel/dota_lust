defmodule DotaLust.Plug.WechatAppletAuthentication do
  import Plug.Conn

  alias DotaLust.WechatAppletUserSession
  alias DotaLust.Repo

  import DotaLust.ResponseHelper, only: [unauthorized_error: 1, unauthorized_error: 2]

  @spec init(any) :: any
  def init(options) do
    options
  end

  @spec call(Plug.Conn.t, any) :: Plug.Conn.t | no_return
  def call(conn, options) do
    case get_req_header(conn, "token") do
      [] ->
        unauthorized_error(conn)
      [token] ->
        case get_resource(token) do
          nil ->
            unauthorized_error(conn)

          resource ->
            conn
              |> assign(:wechat_applet_resource, resource)
              |> user_authentication(resource, options)
        end
    end
  end

  @spec get_resource(binary) :: Ecto.Schema.t
  def get_resource(token) do
    WechatAppletUserSession
      |> WechatAppletUserSession.valid
      |> Repo.get_by(token: token)
  end

  def user_authentication(conn, resource, options) do
    case Keyword.get(options, :user_authentication) do
      true ->
        %WechatAppletUserSession{user: user} = Repo.preload(resource, :user)

        case user do
          nil ->
            unauthorized_error(conn, "user authentication failed")
          current_user ->
            assign(conn, :current_user, current_user)
        end
      _ ->
        conn
    end
  end
end
