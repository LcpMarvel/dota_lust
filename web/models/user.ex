defmodule DotaLust.User do
  use DotaLust.Web, :model

  alias DotaLust.WechatAppletUserSession

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

  @spec insert_or_update_by_wechat_open_id!(binary, map) :: Ecto.Schema.t | no_return
  def insert_or_update_by_wechat_open_id!(wechat_open_id, params) do
    case Repo.get_by(__MODULE__, wechat_open_id: wechat_open_id) do
      nil ->
        user =
          %__MODULE__{}
            |> changeset(params)
            |> Repo.insert!

        WechatAppletUserSession.set_user_id(user)

        user
      record ->
        record
          |> changeset(params)
          |> Repo.update!
    end
  end
end
