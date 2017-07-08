defmodule DotaLust.ETL.Extract.Account do
  alias Dota2API.Mapper.PlayerSummaries, as: Dota2PlayerSummaryAPI

  @spec execute(String.t) :: Dota2API.Model.PlayerSummary.t | nil
  def execute(account_id) do
    case Dota2PlayerSummaryAPI.load(account_id) do
      {:ok, player_summary} ->
        player_summary
      {:error, _} ->
        nil
    end
  end
end
