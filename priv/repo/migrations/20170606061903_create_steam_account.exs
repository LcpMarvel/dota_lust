defmodule DotaLust.Repo.Migrations.CreateSteamAccount do
  use Ecto.Migration

  def change do
    create table(:steam_accounts) do
      add :account_id, :string
      add :steam64_id, :string
      add :community_visibility_state, :integer
      add :display_name, :string
      add :last_sign_out_at, :naive_datetime
      add :profile_url, :string
      add :avatars, :map
      add :persona_state, :integer
      add :realname, :string
      add :created_at, :naive_datetime
      add :valid, :boolean, default: true, null: false

      add :winning_percentage, :float
      add :matches_count, :integer
      add :matches_win_count, :integer

      timestamps()
    end

    create index(:steam_accounts, :account_id)
    create index(:steam_accounts, [:winning_percentage, :matches_count])
    create index(:steam_accounts, :valid)
  end
end
