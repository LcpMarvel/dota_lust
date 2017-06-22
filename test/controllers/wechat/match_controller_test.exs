defmodule DotaLust.Wechat.MatchControllerTest do
  import DotaLust.Factory

  use DotaLust.ConnCase

  alias DotaLust.Repo
  alias DotaLust.EssentialData

  setup do
    resource = insert(:wechat_applet_user_session) |> Repo.preload(:user)
    insert(:steam_account, user: resource.user)

    EssentialData.load_matches

    [wechat_applet_user_session: resource]
  end

  test "#index", %{conn: conn, wechat_applet_user_session: resource} do
    body =
      conn
        |> put_req_header("token", resource.token)
        |> get("/api/wechat/matches")
        |> json_response(200)

    assert length(body) > 0
  end

  test "#show", %{conn: conn, wechat_applet_user_session: resource} do
    match_id = "3241475535"

    body =
      conn
        |> put_req_header("token", resource.token)
        |> get("/api/wechat/matches/#{match_id}")
        |> json_response(200)

    assert body["match_id"] == match_id
  end
end
