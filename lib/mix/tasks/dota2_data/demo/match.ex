defmodule Mix.Tasks.Dota2Data.Demo.Match do
  use Mix.Task

  import Mix.Ecto
  @shortdoc "Prepare matches for demo"

  def run(args) do
    Application.ensure_all_started(:dota2_api)

    repos = parse_repo(args)

    Enum.each repos, fn repo ->
      ensure_repo(repo, args)
      ensure_started(repo, [])

      captains_mode_match_ids = ["3241475535", "3241665434"]
      all_pick_match_ids = ["2853451399", "2758940801"]

      captains_mode_match_ids ++ all_pick_match_ids
        |> Enum.each(&DotaLust.ETL.Match.execute/1)
    end
  end
end
