defmodule DotaLust.Worker.Dota2API.FetchRecentWorker do
  alias Dota2API.Mapper.Matches, as: Dota2MatchesAPI

  alias DotaLust.Repo
  alias DotaLust.Match
  alias DotaLust.SteamAccount
  alias DotaLust.Worker.Dota2API.DetailWorker
  alias DotaLust.AccountSyncChannel

  # DotaLust.Worker.Dota2API.FetchRecentWorker.perform(275477134)
  def perform(steam_account_id, account_id) do
    case Dota2MatchesAPI.load(account_id: account_id, matches_requested: 100) do
      {:ok, _, _, _, match_digests} ->
        match_ids = Enum.map(match_digests, &(&1.match_id))
        uniq_match_ids = uniq(match_ids, existing_match_ids(match_ids))

        total = Enum.count(uniq_match_ids)
        redis_key = AccountSyncChannel.channel(steam_account_id)

        if total > 0 do
          uniq_match_ids
            |> store_in_redis_for_progress(redis_key)
            |> Enum.each(&(fetch_detail(redis_key, &1, total)))
        end
      {:error, _} ->
        SteamAccount
          |> SteamAccount.account_id_scope(account_id)
          |> Repo.update_all(set: [valid: false])
    end
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

  def store_in_redis_for_progress(match_ids, redis_key) do
    commands = Enum.map(match_ids, fn (match_id) ->
      ["HSET", redis_key, match_id, "0"]
    end)

    Redix.pipeline(:redix, commands)

    match_ids
  end

  def fetch_detail(redis_key, match_id, total) do
    Exq.enqueue(Exq, "dota2_api", DetailWorker, [redis_key, match_id, total])
  end
end
