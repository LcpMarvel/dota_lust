defmodule DotaLust.Wechat.SessionControllerTest do
  use DotaLust.ConnCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start

    :ok
  end

  test "#Create", %{conn: conn} do
    use_cassette "wechat_login" do
      code = "081Lp9th2SP2QG046bth29Lath2Lp9tF"
      conn = post conn, "/api/wechat/login", code: code

      body = json_response(conn, 200)

      assert body["token"]
    end
  end
end
