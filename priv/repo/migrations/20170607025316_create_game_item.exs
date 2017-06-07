defmodule DotaLust.Repo.Migrations.CreateGameItem do
  use Ecto.Migration

  def change do
    create table(:game_items) do
      add :game_item_id, :integer
      add :name, :string
      add :cost, :integer
      add :secret_shop, :integer
      add :side_shop, :integer
      add :localized_name, :string
      add :image, :string
    end

    create index(:game_items, :game_item_id, unique: true)
  end
end
