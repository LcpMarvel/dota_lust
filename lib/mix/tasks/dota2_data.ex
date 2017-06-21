defmodule Mix.Tasks.Dota2Data do
  use Mix.Task

  @shortdoc "Prepare Data for Dota2"

  def run(args) do
    Mix.Tasks.Dota2Data.GameItem.run(args)
    Mix.Tasks.Dota2Data.Hero.run(args)

    if Enum.any?(args, &(&1 == "--demo")) do
      Mix.Tasks.Dota2Data.Demo.Match.run(args)
    end
  end
end
