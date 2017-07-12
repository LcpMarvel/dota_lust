defmodule DotaLust.Player do
  use DotaLust.Web, :model

  alias DotaLust.Match

  schema "players" do
    field :account_id, :string
    field :team, FactionEnum
    field :position, :integer
    field :win, :boolean
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

    belongs_to :match, Match, primary_key: :match_id, type: :string
    belongs_to :hero, DotaLust.Hero, primary_key: :hero_id

    has_many :ability_upgrades, DotaLust.AbilityUpgrade
    has_many :items, DotaLust.Item
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :match_id, :account_id, :hero_id, :team, :position, :win, :kills_count, :deaths_count,
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

  @spec account_id_scope(Ecto.queryable, String.t) :: Ecto.Query.t
  def account_id_scope(queryable, account_id) do
    from p in queryable, where: p.account_id == ^account_id
  end

  @spec win_scope(Ecto.queryable) :: Ecto.Query.t
  def win_scope(queryable) do
    from p in queryable, where: p.win == true
  end
end
