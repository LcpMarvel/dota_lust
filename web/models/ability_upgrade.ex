defmodule DotaLust.AbilityUpgrade do
  use DotaLust.Web, :model

  schema "ability_upgrades" do
    belongs_to :player, DotaLust.Player

    field :ability_id, :integer
    field :upgraded_at, :integer
    field :level, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:player_id, :ability_id, :upgraded_at, :level])
      |> validate_required([:ability_id, :upgraded_at, :level])
  end
end
