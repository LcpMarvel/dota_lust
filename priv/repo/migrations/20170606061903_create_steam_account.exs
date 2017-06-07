defmodule DotaLust.Repo.Migrations.CreateSteamAccount do
  use Ecto.Migration

  def change do
    create table(:steam_accounts) do
      add :user_id, references(:users)
      add :account_id, :string

      timestamps()
    end

    create index(:steam_accounts, :account_id)
  end
end
