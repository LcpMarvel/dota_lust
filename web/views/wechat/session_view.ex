defmodule DotaLust.Wechat.SessionView do
  def render("create.json", %{token: token}) do
    %{
      token: token
    }
  end
end
