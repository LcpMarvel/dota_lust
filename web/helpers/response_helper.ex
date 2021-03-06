defmodule DotaLust.ResponseHelper do
  @spec no_content_json(Plug.Conn.t) :: Plug.Conn.t
  def no_content_json(conn) do
    conn
      |> content_type_json
      |> Plug.Conn.send_resp(204, "")
  end

  @spec unauthorized_error(Plug.Conn.t, String.t) :: no_return
  def unauthorized_error(conn, message \\ "unauthorized") do
    conn
      |> content_type_json
      |> Plug.Conn.send_resp(401, message)
      |> Plug.Conn.halt
  end

  @spec unprocessable_entity_error(Plug.Conn.t, String.t) :: no_return
  def unprocessable_entity_error(conn, message \\ "Unprocessable Entity") do
    conn
      |> content_type_json
      |> Plug.Conn.send_resp(422, message)
      |> Plug.Conn.halt
  end

  defp content_type_json(conn) do
    conn
      |> Plug.Conn.put_resp_header("content-type", "application/json")
  end
end
