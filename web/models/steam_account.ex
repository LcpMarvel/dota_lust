defmodule DotaLust.SteamAccount do
  use DotaLust.Web, :model

  schema "steam_accounts" do
    belongs_to :user, DotaLust.User

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

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :user_id, :account_id, :steam64_id, :community_visibility_state,
      :display_name, :last_sign_out_at, :profile_url, :avatars,
      :persona_state, :realname, :created_at
    ]

    struct
      |> cast(params, attributes)
      |> validate_required([:user_id, :account_id])
  end

  def by_account_id(account_id) do
    from a in __MODULE__, where: a.account_id == ^account_id
  end
end
