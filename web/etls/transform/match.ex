defmodule DotaLust.ETL.Transform.Match do
  alias DotaLust.ETL.Transform

  import DotaLust.ETL.Helper, only: [raw_value: 1]

  @type t :: %{
    match_id: String.t,
    sequence_number: String.t,
    season: String.t,
    winner: integer,
    duration: integer,
    started_at: DateTime.t,
    tower_status_of_radiant: String.t,
    tower_status_of_dire: String.t,
    barracks_status_of_radiant: String.t,
    barracks_status_of_dire: String.t,
    server_cluster: integer,
    first_blood_occurred_at: integer,
    lobby_type: integer,
    human_players_count: integer,
    league_id: integer,
    positive_votes_count: integer,
    negative_votes_count: integer,
    game_mode: integer,
    flags: integer,
    engine: integer,
    radiant_score: integer,
    dire_score: integer,
    players: [Transform.Player.t],
    picks_bans: [Transform.PickBan.t]
  }

  @spec execute(Dota2API.Models.Match.t) :: t
  def execute(match) do
    match_id = match.match_id

    %{
      match_id: match_id,
      sequence_number: match.match_sequence_number,
      season: match.season,
      winner: match.winner |> raw_value,
      duration: match.duration,
      started_at: DateTime.from_unix!(match.started_at),
      tower_status_of_radiant: match.tower_status_of_radiant,
      tower_status_of_dire: match.tower_status_of_dire,
      barracks_status_of_radiant: match.barracks_status_of_radiant,
      barracks_status_of_dire: match.barracks_status_of_dire,
      server_cluster: match.server_cluster,
      first_blood_occurred_at: match.first_blood_occurred_at,
      lobby_type: match.lobby_type |> raw_value,
      human_players_count: match.human_players_count,
      league_id: match.league_id,
      positive_votes_count: match.positive_votes_count,
      negative_votes_count: match.negative_votes_count,
      game_mode: match.game_mode |> raw_value,
      flags: match.flags,
      engine: match.engine,
      radiant_score: match.radiant_score,
      dire_score: match.dire_score,
      players: Transform.Player.batch_execute(match_id, match.players),
      picks_bans: Transform.PickBan.batch_execute(match_id, match.picks_bans)
    }
  end
end
