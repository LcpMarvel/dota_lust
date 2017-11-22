defmodule DotaLust.UserSteamAccount do
  use DotaLust.Web, :model

  schema "users_steam_accounts" do
    field :default, :boolean, default: false

    belongs_to :user, DotaLust.User
    belongs_to :steam_account, DotaLust.SteamAccount
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :steam_account_id, :default])
    |> validate_required([:user_id, :steam_account_id])
  end

  @spec wechat_open_id_scope(Ecto.Query.t, String.t) :: Ecto.Query.t
  def wechat_open_id_scope(scope, wechat_open_id) do
    from u_sa in scope,
      join: u in DotaLust.User,
      on: u.id == u_sa.user_id and u.wechat_open_id == ^wechat_open_id
  end

  @spec default_record(Ecto.Query.t, String.t) :: Ecto.Query.t
  def default_record(scope, user_id) do
    scope
      |> user_id_scope(user_id)
      |> default_scope
  end

  @spec default_scope(Ecto.Query.t) :: Ecto.Query.t
  def default_scope(scope) do
    from a in scope, where: a.default == true
  end

  @spec user_id_scope(Ecto.Query.t, String.t) :: Ecto.Query.t
  def user_id_scope(scope, user_id) do
    from a in scope, where: a.user_id == ^user_id
  end
end
