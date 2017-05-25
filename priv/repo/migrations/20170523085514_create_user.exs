defmodule DotaLust.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nick_name, :string
      add :wechat_open_id, :string
      add :gender, :boolean, default: false, null: false
      add :language, :string, default: "zh_CN"
      add :avatar_url, :string
      add :country, :string
      add :province, :string
      add :city, :string

      timestamps()
    end

    create index(:users, [:wechat_open_id])
  end
end
