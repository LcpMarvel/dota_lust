defmodule DotaLust.Wechat.UserControllerTest do
  use DotaLust.ConnCase
  import DotaLust.Factory
  import Ecto.Query

  alias DotaLust.Repo
  alias DotaLust.User

  test "#Update", %{conn: conn} do
    resource = insert(:wechat_applet_user_session)

    conn = conn
      |> put_req_header("token", resource.token)
      |> put("api/wechat/user", request_params())

      assert conn.status == 204
      assert Repo.aggregate(User, :count, :id) == 1
  end

  def request_params do
    %{
      encrypted_data: "kgyMGV0swPQcW1JYkkZ/MoBDOlSbXIrH6VM1++3WiZJwwJIyV2LYgh4XARCy3pzm1j/dNIsvYBjLWH8H+otxMfCuLKxhncC3plbVc6ezB5L9U2YhuEqwRLoTk5PBjgrnow+bHUUP7G7o/euo5MCsgHdAhwMivSBiX8lkK4Ry4XoIFyb+vbG6wJAcUvD1AoEBUoO4rPIlTL1aCZ2/JPAdryYmF4Dzh67gkQifqRYyfHl3J9xPAgJKAbFVUQupRcaJxZV8VrN9B0TngahJNmSwOF0UsZY2KL+gH3sVTmmVYC9iXSC/k8TF9n7/qYzsYmER47DJG4d40TBjvKxGVuVwpkuDRnmJXCRH8eb4P1qEHjrpOPgHWEI27u16huEUFnOBcqa0CMUwwU9z78E1F2m8k9xeycOUnhxpDrTtpySEkCMkElZkeXHgI0T1vKhjQdj/oav76H0iWJMa0+78WrWzqs28l0QgnYeLyxmF6UZpJck=",
      iv: "dLu/ExWWlfw0qtWxxr6JfQ==",
      raw_data: "{\"nickName\":\"吕成鹏\",\"gender\":1,\"language\":\"zh_CN\",\"city\":\"Hangzhou\",\"province\":\"Zhejiang\",\"country\":\"CN\",\"avatarUrl\":\"http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83erDCM1NdGicg4tvIEwHicOrQyt5X3ytjKmW7PRHmCreFUwFibYA8QbYDOb6KPBz5rbJF5ibmibEJYjhpiaA/0\"}",
      signature: "5b3c13467dab89780114109bea09a50967437391"
    }
  end
end
