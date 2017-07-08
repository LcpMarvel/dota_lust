defmodule DotaLust.ETL.Account do
  alias DotaLust.ETL

  @spec execute(String.t) :: Ecto.Schema.t
  def execute(account_id) do
    case ETL.Extract.Account.execute(account_id) do
      nil ->
        nil
      player_summary ->
        player_summary
          |> ETL.Transform.PlayerSummary.execute
          |> ETL.Load.Account.execute
    end
  end
end
