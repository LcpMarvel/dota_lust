defmodule DotaLust.ETL.Transform.Item do
  @type t :: %{
    place: integer,
    position: atom,
    game_item_id: integer
  }

  @spec execute(Dota2API.Models.Player.t) :: [t]
  def execute(player) do
    filter_map(player.items, :wearing)
      ++ filter_map(player.backpack_items, :backpack)
  end

  @spec filter_map([integer], atom) :: [t]
  def filter_map(item_ids, place) do
    item_ids
      |> Enum.with_index
      |> Enum.filter_map(
        fn({id, _}) -> id != 0 end,
        fn({id, index}) -> attributes(id, index, place) end
      )
  end

  @spec attributes(integer, integer, :wearing | :backpack) :: t
  def attributes(item_id, position, place) do
    %{
      place: place,
      position: position,
      game_item_id: item_id
    }
  end
end
