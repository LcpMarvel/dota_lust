defmodule DotaLust.ETL.Transform.AbilityUpgrade do
  @type t :: %{
    ability_id: integer,
    upgraded_at: integer,
    level: integer
  }

  @spec execute(Dota2API.Models.AbilityUpgrade.t) :: t
  def execute(ability_upgrade) do
    %{
      ability_id: ability_upgrade.ability_id,
      upgraded_at: ability_upgrade.upgraded_at,
      level: ability_upgrade.level
    }
  end

  @spec batch_execute([Dota2API.Models.AbilityUpgrade.t]) :: [t]
  def batch_execute(ability_upgrades) do
    ability_upgrades
      |> Enum.map(&execute/1)
  end
end
