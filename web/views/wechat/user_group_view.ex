defmodule DotaLust.Wechat.UserGroupView do
  def render("create.json", %{user_group: user_group}) do
    %{
      group_id: user_group.group_id
    }
  end
end
