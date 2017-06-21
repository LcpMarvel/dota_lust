defmodule DotaLust.ETL.Load.Account do
  alias DotaLust.Repo
  alias DotaLust.SteamAccount

  @spec execute(Keyword.t) :: Ecto.Schema.t | no_return
  def execute(keywords) do
    SteamAccount
      |> SteamAccount.account_id_scope(keywords[:account_id])
      |> Repo.update_all(set: keywords)
  end
end
