defmodule DotaLust.Player do
  use DotaLust.Web, :model

  schema "players" do
    field :account_id, :string
    field :player_slot, :string
    field :kills_count, :integer
    field :deaths_count, :integer
    field :assists_count, :integer
    field :kda, :float
    field :leaver_status, LeaverStatusEnum
    field :last_hits_count, :integer
    field :denies_count, :integer
    field :gold, :integer
    field :gold_per_minute, :integer
    field :experience_per_minute, :integer
    field :gold_spent, :integer
    field :hero_damage, :integer
    field :tower_damage, :integer
    field :hero_healing, :integer
    field :level, :integer

    belongs_to :match, DotaLust.Match, primary_key: :match_id, type: :string
    belongs_to :hero, DotaLust.Hero, primary_key: :hero_id

    has_many :ability_upgrades, DotaLust.AbilityUpgrade
    has_many :items, DotaLust.Item
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :match_id, :account_id, :player_slot, :hero_id, :kills_count, :deaths_count,
      :assists_count, :kda, :leaver_status, :last_hits_count, :denies_count, :gold,
      :gold_per_minute, :experience_per_minute, :gold_spent, :hero_damage, :tower_damage,
      :hero_healing, :level
    ]

    struct
      |> cast(params, attributes)
      |> validate_required([:match_id, :account_id, :hero_id])
      |> cast_assoc(:ability_upgrades)
      |> cast_assoc(:items)
  end
end
