defmodule DotaLust.Workers.Dota2API.DetailWorker do
  alias Dota2API.Mappers.Match, as: Dota2MatchAPI
  alias DotaLust.Repo
  alias DotaLust.Match

  def perform(match_id) do
    {:ok, match} = Dota2MatchAPI.load(match_id)

    parse(match)
  end

  def parse(match) do
    case Repo.get_by(Match, match_id: match.match_id) do
      nil ->
        %Match{}
          |> Match.changeset(attributes(match))
          |> Repo.insert!
      _ ->
        :ok
    end
  end

  def attributes(match) do
    %{
      match_id: match.match_id,
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
      dire_score: match.dire_score
    }
  end

  def raw_value(enum) do
    if enum do
      enum.value.value
    end
  end
end
