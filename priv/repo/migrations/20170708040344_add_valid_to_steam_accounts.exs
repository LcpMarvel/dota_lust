defmodule DotaLust.Repo.Migrations.AddValidToSteamAccounts do
  use Ecto.Migration

  def change do
    alter table(:steam_accounts) do
      add :valid, :boolean, default: true, null: false
    end

    create index(:steam_accounts, :valid)
  end
end
