defmodule DotaLust.Repo.Migrations.CreateAbilityUpgrade do
  use Ecto.Migration

  def change do
    create table(:ability_upgrades) do
      add :player_id, references(:players)
      add :ability_id, :integer
      add :upgraded_at, :integer
      add :level, :integer
    end

    create index(:ability_upgrades, :upgraded_at)
  end
end
