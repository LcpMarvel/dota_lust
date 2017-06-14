defmodule DotaLust.ETL.Extract.Account do
  alias Dota2API.Mapper.PlayerSummaries, as: Dota2PlayerSummaryAPI

  @spec execute(String.t) :: Dota2API.Model.PlayerSummary.t
  def execute(account_id) do
    {:ok, player_summary} = Dota2PlayerSummaryAPI.load(account_id)

    player_summary
  end
end
