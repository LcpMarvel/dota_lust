defmodule DotaLust.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :player_id, references(:players)
      add :game_item_id, references(:game_items, column: :game_item_id)
      add :position, :integer
      add :place, :integer
    end

    create index(:items, :position)
    create index(:items, :place)
  end
end
