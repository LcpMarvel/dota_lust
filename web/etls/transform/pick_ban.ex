defmodule DotaLust.ETL.Transform.PickBan do
  @type t :: %{
    match_id: String.t,
    hero_id: integer,
    is_pick: boolean,
    team: integer,
    order: integer
  }

  @spec execute(String.t, Dota2API.Model.PickBan.t) :: t
  def execute(match_id, pick_ban) do
    %{
      match_id: match_id,
      hero_id: pick_ban.hero_id,
      is_pick: pick_ban.is_pick,
      team: pick_ban.team,
      order: pick_ban.order
    }
  end

  @spec batch_execute(String.t, [Dota2API.Model.PickBan.t] | nil) :: [t]
  def batch_execute(_, nil) do
    []
  end
  def batch_execute(match_id, picks_bans) do
    picks_bans
      |> Enum.map(fn(pick_ban) -> execute(match_id, pick_ban) end)
  end
end
