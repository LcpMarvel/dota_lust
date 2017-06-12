defmodule DotaLust.ETL.MatchTest do
  use DotaLust.ModelCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "load data to db" do
    DotaLust.EssentialData.load

    use_cassette "load_match" do
      DotaLust.ETL.Match.execute("3219145772")

      match =
        DotaLust.Match
          |> Ecto.Query.first
          |> Repo.one
          |> Repo.preload(:players)

      assert(match)
      assert(Enum.count(match.players) == 10)
    end
  end
end
