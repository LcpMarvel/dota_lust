defmodule DotaLust.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :match_id, references(:matches, column: :match_id, type: :string)
      add :account_id, :string
      add :player_slot, :string
      add :hero_id, references(:heroes, column: :hero_id)
      add :kills_count, :integer
      add :deaths_count, :integer
      add :assists_count, :integer
      add :kda, :float
      add :leaver_status, :integer
      add :last_hits_count, :integer
      add :denies_count, :integer
      add :gold, :integer
      add :gold_per_minute, :integer
      add :experience_per_minute, :integer
      add :gold_spent, :integer
      add :hero_damage, :integer
      add :tower_damage, :integer
      add :hero_healing, :integer
      add :level, :integer
    end
  end
end
