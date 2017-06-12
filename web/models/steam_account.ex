defmodule DotaLust.SteamAccount do
  use DotaLust.Web, :model

  schema "steam_accounts" do
    belongs_to :user, DotaLust.User

    field :account_id, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:user_id, :account_id])
      |> validate_required([:user_id, :account_id])
  end
end
