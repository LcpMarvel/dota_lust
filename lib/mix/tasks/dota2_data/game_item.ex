defmodule Mix.Tasks.Dota2Data.GameItem do
  use Mix.Task

  alias DotaLust.Repo
  alias DotaLust.GameItem
  alias Dota2API.Mapper.GameItems, as: GameItemAPI
  alias Dota2API.Model.GameItem, as: GameItemModel

  import Mix.Ecto

  @shortdoc "Prepare game item for Dota2"

  def run(args) do
    Application.ensure_all_started(:dota2_api)

    repos = parse_repo(args)

    Enum.each repos, fn repo ->
      ensure_repo(repo, args)
      ensure_started(repo, [])

      {:ok, game_items} = GameItemAPI.load("zh")

      game_items
        |> Enum.map(&upsert/1)
    end
  end

  def upsert(%GameItemModel{} = game_item) do
    attributes = attributes(game_item)

    case Repo.get_by(GameItem, game_item_id: game_item.id) do
      nil ->
        %GameItem{}
          |> GameItem.changeset(attributes)
          |> Repo.insert!
      record ->
        record
          |> GameItem.changeset(attributes)
          |> Repo.update!
    end
  end

  def attributes(%GameItemModel{} = game_item) do
    %{
      game_item_id: game_item.id,
      name: game_item.name,
      cost: game_item.cost,
      secret_shop: game_item.secret_shop,
      side_shop: game_item.side_shop,
      recipe: game_item.recipe,
      localized_name: game_item.localized_name,
      image: game_item.image
    }
  end
end
