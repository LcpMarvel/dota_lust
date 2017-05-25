defmodule DotaLust.Factory do
  use ExMachina.Ecto, repo: DotaLust.Repo

  use DotaLust.WechatAppletUserSessionFactory
end
