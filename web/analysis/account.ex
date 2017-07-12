defmodule DotaLust.Analysis.Account do
  alias DotaLust.Repo

  alias DotaLust.Player
  alias DotaLust.Match

  import Ecto.Query

  @spec winning_percentage(String.t) :: float
  def winning_percentage(account_id) do
    case matches_count(account_id) do
      0 ->
        0.0
      matches_count ->
        win_count = matches_win_count(account_id)

        Float.round(win_count / matches_count * 100, 2)
    end
  end

  @spec matches_count(String.t) :: integer
  def matches_count(account_id) do
    Player
      |> Player.account_id_scope(account_id)
      |> Repo.aggregate(:count, :id)
  end

  @spec matches_win_count(String.t) :: integer
  def matches_win_count(account_id) do
    Player
      |> Player.account_id_scope(account_id)
      |> Player.win_scope
      |> Repo.aggregate(:count, :id)
  end

  def recent_matches_summary(account_id, matches_count \\ 20) do
    players_scope =
      Player
        |> Player.account_id_scope(account_id)

    from m in Match,
      join: p in ^players_scope, on: p.match_id == m.match_id,
      group_by: [m.match_id, m.id],
      limit: ^matches_count,
      order_by: [desc: m.match_id],
      select: %{
        schema: m,
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
