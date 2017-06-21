defmodule DotaLust.EssentialData do
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  def load do
    use_cassette "load_essential_data" do
      Mix.Tasks.Dota2Data.run([])
    end
  end

  def load_matches do
    load()

    match_ids = ["3241475535", "3241665434", "2853451399", "2758940801"]

    Enum.each(match_ids, &load_match/1)
  end

  def load_match(match_id) do
    use_cassette "load_matches_#{match_id}" do
      DotaLust.ETL.Match.execute(match_id)
    end
  end
end
