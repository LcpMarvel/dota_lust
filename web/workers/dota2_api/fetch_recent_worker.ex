defmodule DotaLust.Workers.Dota2API.FetchRecentWorker do
  alias Dota2API.Mapper.Matches, as: Dota2MatchesAPI

  alias DotaLust.Repo
  alias DotaLust.Match
  alias DotaLust.Workers.Dota2API.DetailWorker

  # DotaLust.Workers.Dota2API.FetchRecentWorker.perform(275477134)
  def perform(account_id) do
    {:ok, _, _, _, match_digests} = Dota2MatchesAPI.load(
      account_id: account_id, matches_requested: 20
    )

    match_ids = Enum.map(match_digests, &(&1.match_id))

    match_ids
      |> uniq(existing_match_ids(match_ids))
      |> Enum.each(&fetch_detail/1)
  end

  def uniq(match_ids, existing_match_ids) do
    match_ids
      |> MapSet.new
      |> MapSet.difference(existing_match_ids)
  end

  def existing_match_ids(ids) do
    ids
      |> Match.existing_match_ids_query
      |> Repo.all
      |> MapSet.new
  end

  def fetch_detail(match_id) do
    Exq.enqueue(Exq, "dota2_api", DetailWorker, [match_id])
  end
end
