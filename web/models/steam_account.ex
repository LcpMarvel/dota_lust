defmodule DotaLust.SteamAccount do
  use DotaLust.Web, :model

  alias DotaLust.User

  schema "steam_accounts" do
    belongs_to :user, User

    field :account_id, :string
    field :steam64_id, :string
    field :community_visibility_state, :integer
    field :display_name, :string
    field :last_sign_out_at, :naive_datetime
    field :profile_url, :string
    field :avatars, :map
    field :persona_state, :integer
    field :realname, :string
    field :created_at, :naive_datetime
    field :default, :boolean, default: false
    field :winning_percentage, :float, default: 0.0
    field :matches_count, :integer, default: 0
    field :matches_win_count, :integer, default: 0
    field :valid, :boolean, default: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :user_id, :account_id, :steam64_id, :community_visibility_state,
      :display_name, :last_sign_out_at, :profile_url, :avatars,
      :persona_state, :realname, :created_at, :default,
      :winning_percentage, :matches_count, :matches_win_count
    ]

    struct
      |> cast(params, attributes)
      |> validate_required([:user_id, :account_id])
  end

  @spec default_record(Ecto.Query.t, String.t) :: Ecto.Query.t
  def default_record(scope, user_id) do
    scope
      |> user_id_scope(user_id)
      |> default_scope
  end

  @spec default_scope(Ecto.Query.t) :: Ecto.Query.t
  def default_scope(scope) do
    from a in scope, where: a.default == true and a.valid == true
  end

  @spec account_id_scope(Ecto.Query.t, String.t) :: Ecto.Query.t
  def account_id_scope(scope, account_id) do
    from a in scope, where: a.account_id == ^account_id
  end

  @spec user_id_scope(Ecto.Query.t, String.t) :: Ecto.Query.t
  def user_id_scope(scope, user_id) do
    from a in scope, where: a.user_id == ^user_id
  end

  @spec user_id_scope(Ecto.Query.t, String.t, integer) :: Ecto.Query.t
  def user_id_scope(scope, user_id, limit) do
    from a in scope, where: a.user_id == ^user_id, limit: ^limit
  end

  def wechat_open_id_scope(scope, wechat_open_id) do
    from a in scope,
      join: u in User, on: u.id == a.user_id,
      select: a,
      where: u.wechat_open_id == ^wechat_open_id
  end
end
