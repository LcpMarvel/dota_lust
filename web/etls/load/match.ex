defmodule DotaLust.ETL.Load.Match do
  alias DotaLust.Repo
  alias DotaLust.Match

  @spec execute(map) :: Ecto.Schema.t | no_return
  def execute(map) do
    %Match{}
      |> Repo.preload(:picks_bans, players: [:ability_upgrades, :items])
      |> Match.changeset(map)
      |> Repo.insert!
  end
end
