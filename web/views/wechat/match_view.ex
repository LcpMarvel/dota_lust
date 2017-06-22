defmodule DotaLust.Wechat.MatchView do
  def render("index.json", %{matches: matches}) do
    Enum.map(matches, &render_match/1)
  end

  def render("show.json", %{match: match}) do
    render_match(match)
  end

  defp render_match(match) do
    %{
      match_id: match.match_id
    }
  end
end
