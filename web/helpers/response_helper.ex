defmodule DotaLust.ResponseHelper do
  @spec no_content_json(Plug.Conn.t) :: Plug.Conn.t
  def no_content_json(conn) do
    conn
      |> Plug.Conn.put_resp_header("content-type", "application/json")
      |> Plug.Conn.send_resp(204, "")
  end

  @spec unauthorized_error(Plug.Conn.t, String.t) :: no_return
  def unauthorized_error(conn, message \\ "unauthorized") do
    conn
      |> Plug.Conn.send_resp(401, message)
      |> Plug.Conn.halt
  end
end
