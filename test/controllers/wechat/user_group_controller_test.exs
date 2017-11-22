defmodule DotaLust.Wechat.UserGroupControllerTest do
  use DotaLust.ConnCase

  import DotaLust.Factory

  alias DotaLust.Repo
  alias DotaLust.UserGroup

  test "#create", %{conn: conn} do
    resource = insert(:wechat_applet_user_session, session_key: "UyZzzBEgSFYYR176rXqVnA==")

    conn
      |> put_req_header("token", resource.token)
      |> post("api/wechat/users_groups", request_params())

    assert Repo.get_by!(UserGroup, wechat_open_id: resource.wechat_open_id)
  end

  def request_params do
    %{
      encrypted_data: "z4fwHglaWp4ZbdAbj57YWRENr6z/qteMz5HyxO1vCRFj8P7+rkTCAPIildfXr+dawSyyH4JjAStLSMcmvNEgaN2JkE9qP7J87QCPBSF0obmAqqGTsJhf7xOdxyYBhepSUvZKRpWHXV9ciw49qaCKMw==",
      iv: "88be+6IqaAV6CQr0FXQh5A=="
    }
  end
end
