defmodule DotaLust.SteamAccount do
  use DotaLust.Web, :model

  alias DotaLust.User

  schema "steam_accounts" do
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
    field :valid, :boolean, default: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :account_id, :steam64_id, :community_visibility_state,
      :display_name, :last_sign_out_at, :profile_url, :avatars,
      :persona_state, :realname, :created_at
    ]

    struct
      |> cast(params, attributes)
      |> validate_required([:account_id])
  end

  @spec account_id_scope(Ecto.Query.t, String.t) :: Ecto.Query.t
  def account_id_scope(scope, account_id) do
    from a in scope, where: a.account_id == ^account_id
  end
end
