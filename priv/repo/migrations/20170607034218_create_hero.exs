defmodule DotaLust.Repo.Migrations.CreateHero do
  use Ecto.Migration

  def change do
    create table(:heroes) do
      add :hero_id, :integer
      add :name, :string
      add :hero_name, :string
      add :localized_name, :string
      add :avatars, :jsonb
    end

    create index(:heroes, :hero_id, unique: true)
  end
end
