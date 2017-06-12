defmodule DotaLust.Repo.Migrations.CreatePickBan do
  use Ecto.Migration

  def change do
    create table(:picks_bans) do
      add :match_id, references(:matches, column: :match_id, type: :string)
      add :hero_id, references(:heroes, column: :hero_id)
      add :is_pick, :boolean, default: false, null: false
      add :team, :integer
      add :order, :integer
    end

    create index(:picks_bans, :order)
  end
end
