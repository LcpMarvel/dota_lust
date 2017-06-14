defmodule DotaLust.Worker.Dota2API.DetailWorker do
  alias DotaLust.ETL

  def perform(match_id) do
    ETL.Match.execute(match_id)
  end
end
