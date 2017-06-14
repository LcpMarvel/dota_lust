defmodule DotaLust.Worker.Dota2API.FetchAccountInfoWorker do
  alias DotaLust.ETL

  def perform(account_id) do
    ETL.Account.execute(account_id)
  end
end
