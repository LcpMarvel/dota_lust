defmodule DotaLust.ETL.Match do
  alias DotaLust.ETL
  import DotaLust.Match, only: [expected_ranked_modes: 0]

  @spec execute(String.t) :: Ecto.Schema.t
  def execute(match_id) do
    match = ETL.Extract.Match.execute(match_id)

    if Enum.member?(expected_ranked_modes(), match.game_mode) do
      match
        |> ETL.Transform.Match.execute
        |> ETL.Load.Match.execute
    end
  end
end
