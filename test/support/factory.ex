defmodule DotaLust.Factory do
  use ExMachina.Ecto, repo: DotaLust.Repo

  use DotaLust.WechatAppletUserSessionFactory
  use DotaLust.UserFactory
  use DotaLust.SteamAccountFactory
  use DotaLust.UserSteamAccountFactory
end
