defmodule DotaLust.Wechat.MatchControllerTest do
  import DotaLust.Factory

  use DotaLust.ConnCase

  alias DotaLust.Repo
  alias DotaLust.EssentialData

  test "#Index", %{conn: conn} do
    resource = insert(:wechat_applet_user_session) |> Repo.preload(:user)
    insert(:steam_account, user: resource.user)

    EssentialData.load_matches

    body =
      conn
        |> put_req_header("token", resource.token)
        |> get("/api/wechat/matches")
        |> json_response(200)

    assert length(body) > 0
  end
end
