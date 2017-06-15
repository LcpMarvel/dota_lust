defmodule DotaLust.Repo.Migrations.AddDefaultToSteamAccounts do
  use Ecto.Migration

  def change do
    alter table(:steam_accounts) do
      add :default, :boolean, default: false, null: false
    end

    create index(:steam_accounts, :default)
  end
end
