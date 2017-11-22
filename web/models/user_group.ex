defmodule DotaLust.UserGroup do
  use DotaLust.Web, :model

  schema "users_groups" do
    field :wechat_open_id, :string
    field :group_id, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:wechat_open_id, :group_id])
      |> unique_constraint(:group_id, name: :users_groups_group_id_wechat_open_id_index)
      |> validate_required([:wechat_open_id, :group_id])
  end
end
