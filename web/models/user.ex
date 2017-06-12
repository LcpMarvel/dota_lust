defmodule DotaLust.User do
  use DotaLust.Web, :model

  schema "users" do
    field :nick_name, :string
    field :wechat_open_id, :string
    field :gender, :boolean, default: false
    field :language, :string, default: "zh_CN"
    field :avatar_url, :string
    field :country, :string
    field :province, :string
    field :city, :string

    has_many :steam_accounts, DotaLust.SteamAccount

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nick_name, :wechat_open_id, :gender, :language, :avatar_url, :country, :province, :city])
    |> validate_required([:nick_name])
  end
end
