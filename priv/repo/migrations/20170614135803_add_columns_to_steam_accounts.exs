defmodule DotaLust.Repo.Migrations.AddColumnsToSteamAccounts do
  use Ecto.Migration

  def change do
    alter table(:steam_accounts) do
      add :steam64_id, :string
      add :community_visibility_state, :integer
      add :display_name, :string
      add :last_sign_out_at, :naive_datetime
      add :profile_url, :string
      add :avatars, :map
      add :persona_state, :integer
      add :realname, :string
      add :created_at, :naive_datetime
    end
  end
end
