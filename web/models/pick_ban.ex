defmodule DotaLust.PickBan do
  use DotaLust.Web, :model

  schema "picks_bans" do
    field :is_pick, :boolean, default: false
    field :team, FactionEnum
    field :order, :integer

    belongs_to :match, DotaLust.Match, primary_key: :match_id, type: :string
    belongs_to :hero, DotaLust.Hero, foreign_key: :hero_id
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:match_id, :hero_id, :is_pick, :team, :order])
      |> validate_required([:match_id, :hero_id, :is_pick, :team, :order])
  end
end
