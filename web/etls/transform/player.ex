defmodule DotaLust.ETL.Transform.Player do
  alias DotaLust.ETL.Transform
  alias Dota2API.Enum.Faction

  @type t :: %{
    match_id: String.t,
    account_id: String.t,
    team: integer,
    position: integer,
    win: boolean,
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

  @spec execute(Dota2API.Model.Match.t, Dota2API.Model.Player.t) :: t
  def execute(match, player) do
    %{
      match_id: match.match_id,
      account_id: player.account_id,
      team: player.team |> Faction.raw_value,
      position: player.position,
      win: match.winner === player.team,
      hero_id: player.hero_id,
      kills_count: player.kills_count,
      deaths_count: player.deaths_count,
      assists_count: player.assists_count,
      kda: kda_of_player(player),
      leaver_status: Dota2API.Enum.LeaverStatus.raw_value(player.leaver_status),
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

  @spec batch_execute(Dota2API.Model.Match.t, [Dota2API.Model.Player.t]) :: [map]
  def batch_execute(match, players) do
    players
      |> Enum.map(fn(player) -> execute(match, player) end)
  end

  @spec kda_of_player(Dota2API.Model.Player.t) :: float
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
