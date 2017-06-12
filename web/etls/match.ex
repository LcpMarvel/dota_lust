defmodule DotaLust.ETL.Match do
  alias DotaLust.ETL

  @spec execute(String.t) :: Ecto.Schema.t
  def execute(match_id) do
    match_id
      |> ETL.Extract.Match.execute
      |> ETL.Transform.Match.execute
      |> ETL.Load.Match.execute
  end
end
