defmodule DotaLust.Worker.Dota2API.DetailWorker do
  alias DotaLust.ETL
  alias DotaLust.Endpoint

  def perform(redis_key, match_id, total) do
    ETL.Match.execute(match_id)

    commands = [
      ["HSET", redis_key, match_id, "1"],
      ["HGETALL", redis_key]
    ]

    [_, array] = Redix.pipeline!(:redix, commands)
    key_value_array = Enum.chunk(array, 2)

    progress = calculate_progress(key_value_array, total)
    broadcast!(redis_key, progress)
  end

  def current_progress(redis_key) do
    case Redix.command(:redix, ["HGETALL", redis_key]) do
      {:ok, array} ->
        key_value_array = Enum.chunk(array, 2)
        total = Enum.count(key_value_array)

        calculate_progress(key_value_array, total)
      _ -> 0
    end
  end

  def calculate_progress(key_value_array, total) do
    finished_count =
      key_value_array
        |> Enum.count(fn([_, v]) -> v == "1" end)

    case total do
      0 -> 100
      t ->
        finished_count / t * 100
          |> Float.round(0)
          |> round
    end
  end

  def broadcast!(channel, percent) do
    channel
      |> Endpoint.broadcast!("new_progress", %{percent: percent})
  end
end
