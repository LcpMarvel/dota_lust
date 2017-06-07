defmodule DotaLust.Workers.Dota2API.FetchRecentWorker do
  alias Dota2API.Mappers.Matches, as: Dota2MatchesAPI

  alias DotaLust.Match
  alias DotaLust.Workers.Dota2API.DetailWorker

  # DotaLust.Workers.Dota2API.FetchRecentWorker.perform(275477134)
  def perform(account_id) do
    {:ok, _, _, _, match_digests} = Dota2MatchesAPI.load(
      account_id: account_id, matches_requested: 20
    )

    match_digests
      |> to_match_ids
      |> uniq
      |> Enum.each(&fetch_detail/1)
  end

  def to_match_ids(match_digests) do
    Enum.reduce(
      match_digests, MapSet.new,
      fn(match_digest, set) ->
        MapSet.put(set, match_digest.match_id)
      end
    )
  end

  def uniq(%MapSet{} = match_ids) do
    ids = MapSet.to_list(match_ids)

    match_ids
      |> MapSet.difference(Match.existing_match_ids(ids))
  end

  def fetch_detail(match_id) do
    Exq.enqueue(Exq, "dota2_api", DetailWorker, [match_id])
  end
end
