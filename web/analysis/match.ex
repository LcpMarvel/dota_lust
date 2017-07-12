defmodule DotaLust.Analysis.Match do
  alias DotaLust.Repo

  alias DotaLust.Player
  alias DotaLust.Match

  import Ecto.Query

  @spec recent_matches_summary(String.t, integer) :: [map]
  def recent_matches_summary(account_id, limit \\ 20) do
    result =
      summary_query(account_id, limit)
        |> Repo.all

    matches_count = Enum.count(result)

    if matches_count > 0 do
      win_count = Enum.count(result, fn(%{schema: p}) -> p.win end)

      winning_percentage = Float.round(win_count / matches_count * 100, 2)

      [map|_] = result

      %{
        winning_percentage: winning_percentage,
        kills_count_avg: map.kills_count_avg |> Decimal.to_float,
        deaths_count_avg: map.deaths_count_avg |> Decimal.to_float,
        assists_count_avg: map.assists_count_avg |> Decimal.to_float,
        gold_per_minute_avg: map.gold_per_minute_avg |> Decimal.to_float,
        hero_healing_avg: map.hero_healing_avg |> Decimal.to_float,
        hero_damage_avg: map.hero_damage_avg |> Decimal.to_float,
        last_hits_count_avg: map.last_hits_count_avg |> Decimal.to_float,
        experience_per_minute_avg: map.experience_per_minute_avg |> Decimal.to_float,
        kda_avg: map.kda_avg
      }
    else
      %{
        winning_percentage: 0,
        kills_count_avg: 0,
        deaths_count_avg: 0,
        assists_count_avg: 0,
        gold_per_minute_avg: 0,
        hero_healing_avg: 0,
        hero_damage_avg: 0,
        last_hits_count_avg: 0,
        experience_per_minute_avg: 0,
        kda_avg: 0
      }
    end
  end

  @spec summary_query(String.t, integer) :: Ecto.Query.t
  defp summary_query(account_id, limit) do
    players_scope =
      Player
        |> Player.account_id_scope(account_id)

    from m in Match.ranked(Match),
      join: p in ^players_scope, on: p.match_id == m.match_id,
      group_by: [p.id, m.match_id],
      limit: ^limit,
      order_by: [desc: m.match_id],
      select: %{
        schema: p,
        kills_count_avg: avg(p.kills_count),
        deaths_count_avg: avg(p.deaths_count),
        assists_count_avg: avg(p.assists_count),
        gold_per_minute_avg: avg(p.gold_per_minute),
        hero_healing_avg: avg(p.hero_healing),
        hero_damage_avg: avg(p.hero_damage),
        last_hits_count_avg: avg(p.last_hits_count),
        experience_per_minute_avg: avg(p.experience_per_minute),
        kda_avg: avg(p.kda)
      }
  end
end
