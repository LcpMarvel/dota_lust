defmodule DotaLust.Item do
  use DotaLust.Web, :model

  schema "items" do
    field :position, :integer
    field :place, GameItemPlaceEnum

    belongs_to :player, DotaLust.Player
    belongs_to :game_item, DotaLust.GameItem, foreign_key: :game_item_id
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:player_id, :game_item_id, :position, :place])
      |> validate_required([:game_item_id, :position, :place])
  end
end
