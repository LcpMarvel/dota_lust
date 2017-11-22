defmodule DotaLust.Repo.Migrations.CreateUserSteamAccount do
  use Ecto.Migration

  def change do
    create table(:users_steam_accounts) do
      add :user_id, references(:users)
      add :steam_account_id, references(:steam_accounts)

      add :default, :boolean, default: false, null: false
    end

    create index(:users_steam_accounts, :default)
    create index(:users_steam_accounts, [:user_id, :steam_account_id], unique: true)
  end
end
