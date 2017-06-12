defmodule DotaLust.EssentialData do
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  def load do
    use_cassette "load_essential_data" do
      Mix.Tasks.Dota2Data.run([])
    end
  end
end
