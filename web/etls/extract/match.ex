defmodule DotaLust.ETL.Extract.Match do
  alias Dota2API.Mapper.Match, as: Dota2MatchAPI

  @spec execute(String.t) :: Dota2API.Models.Match.t
  def execute(match_id) do
    {:ok, match} = Dota2MatchAPI.load(match_id)

    match
  end
end
