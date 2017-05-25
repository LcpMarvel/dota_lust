defmodule DotaLust.PageController do
  use DotaLust.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
