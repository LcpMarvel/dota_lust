defmodule DotaLust.ETL.Transform.Player do
  alias DotaLust.ETL.Transform

  import DotaLust.ETL.Helper, only: [raw_value: 1]

  @type t :: %{
    match_id: String.t,
    account_id: String.t,
    player_slot: String.t,
    hero_id: integer,
    kills_count: integer,
    deaths_count: integer,
    assists_count: integer,
    kda: float,
    leaver_status: integer,
    last_hits_count: integer,
    denies_count: integer,
    gold: integer,
    gold_per_minute: integer,
    experience_per_minute: integer,
    gold_spent: integer,
    hero_damage: integer,
    tower_damage: integer,
    hero_healing: integer,
    level: integer,
    items: [Transform.Item.t],
    ability_upgrades: [Transform.AbilityUpgrade.t]
  }

  @spec execute(String.t, Dota2API.Models.Player.t) :: t
  def execute(match_id, player) do
    %{
      match_id: match_id,
      account_id: player.account_id,
      player_slot: player.player_slot,
      hero_id: player.hero_id,
      kills_count: player.kills_count,
      deaths_count: player.deaths_count,
      assists_count: player.assists_count,
      kda: kda_of_player(player),
      leaver_status: player.leaver_status |> raw_value,
      last_hits_count: player.last_hits_count,
      denies_count: player.denies_count,
      gold: player.gold,
      gold_per_minute: player.gold_per_minute,
      experience_per_minute: player.experience_per_minute,
      gold_spent: player.gold_spent,
      hero_damage: player.hero_damage,
      tower_damage: player.tower_damage,
      hero_healing: player.hero_healing,
      level: player.level,
      items: Transform.Item.execute(player),
      ability_upgrades: Transform.AbilityUpgrade.batch_execute(player.ability_upgrades)
    }
  end

  @spec batch_execute(String.t, [Dota2API.Models.Player.t]) :: [map]
  def batch_execute(match_id, players) do
    players
      |> Enum.map(fn(player) -> execute(match_id, player) end)
  end

  @spec kda_of_player(Dota2API.Models.Player.t) :: float
  def kda_of_player(player) do
    kda(
      player.kills_count,
      player.deaths_count,
      player.assists_count
    )
  end

  @spec kda(integer, integer, integer) :: float
  def kda(kills, deaths, assists) do
    ka = kills + assists

    case deaths do
      0 ->
        ka
      _ ->
        Float.round(ka / deaths, 1)
    end
  end
end
