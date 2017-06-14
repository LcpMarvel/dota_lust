defmodule DotaLust.ETL.Account do
  alias DotaLust.ETL

  @spec execute(String.t) :: Ecto.Schema.t
  def execute(account_id) do
    account_id
      |> ETL.Extract.Account.execute
      |> ETL.Transform.PlayerSummary.execute
      |> ETL.Load.Account.execute
  end
end
