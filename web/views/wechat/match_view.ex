defmodule DotaLust.Wechat.MatchView do
  def render("index.json", %{matches: matches}) do
    Enum.map(matches, &render_match/1)
  end

  defp render_match(match) do
    %{
      match_id: match.match_id
    }
  end
end
