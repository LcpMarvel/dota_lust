defmodule DotaLust.Repo.Migrations.CreateWechatAppletUserSession do
  use Ecto.Migration

  def change do
    create table(:wechat_applet_user_sessions) do
      add :wechat_open_id, :string
      add :user_id, references(:users)
      add :session_key, :string
      add :token, :string
      add :expired_at, :naive_datetime

      timestamps()
    end

    create index(:wechat_applet_user_sessions, [:wechat_open_id])
    create index(:wechat_applet_user_sessions, [:token, :expired_at])
  end
end
