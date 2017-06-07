defmodule DotaLust.Repo.Migrations.CreateMatch do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :match_id, :string
      add :sequence_number, :string
      add :season, :string
      add :winner, :integer
      add :duration, :integer
      add :started_at, :naive_datetime
      add :tower_status_of_radiant, :string
      add :tower_status_of_dire, :string
      add :barracks_status_of_radiant, :string
      add :barracks_status_of_dire, :string
      add :server_cluster, :integer
      add :first_blood_occurred_at, :integer
      add :lobby_type, :integer
      add :human_players_count, :integer
      add :league_id, :integer
      add :positive_votes_count, :integer
      add :negative_votes_count, :integer
      add :game_mode, :integer
      add :flags, :integer
      add :engine, :integer
      add :radiant_score, :integer
      add :dire_score, :integer

      timestamps()
    end

  end
end
