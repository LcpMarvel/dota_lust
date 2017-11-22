defmodule DotaLust.Repo.Migrations.CreateUserGroup do
  use Ecto.Migration

  def change do
    create table(:users_groups) do
      add :wechat_open_id, references(:users, column: :wechat_open_id, type: :string)
      add :group_id, :string
    end

    create index(:users_groups, [:group_id, :wechat_open_id], unique: true)
  end
end
