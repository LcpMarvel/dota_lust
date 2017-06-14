defmodule DotaLust.ETL.AccountTest do
  use DotaLust.ModelCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import DotaLust.Factory

  alias DotaLust.SteamAccount

  test "load data to db" do
    DotaLust.EssentialData.load
    insert(:steam_account)

    use_cassette "load_account" do
      account_id = "275477134"

      DotaLust.ETL.Account.execute(account_id)

      account =
        account_id
          |> SteamAccount.by_account_id
          |> Repo.one

      assert(account.steam64_id)
    end
  end
end
