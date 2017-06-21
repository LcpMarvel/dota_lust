defmodule Mix.Tasks.Dota2Data.Hero do
  use Mix.Task

  alias DotaLust.Repo
  alias DotaLust.Hero
  alias Dota2API.Mapper.Heroes, as: HeroAPI
  alias Dota2API.Model.Hero, as: HeroModel

  import Mix.Ecto

  @shortdoc "Prepare hero for Dota2"

  def run(args) do
    Application.ensure_all_started(:dota2_api)

    repos = parse_repo(args)

    Enum.each repos, fn repo ->
      ensure_repo(repo, args)
      ensure_started(repo, [])

      {:ok, heroes, _} = HeroAPI.load("zh")

      heroes
        |> Enum.map(&upsert/1)
    end
  end

  def upsert(%HeroModel{} = hero) do
    attributes = attributes(hero)

    case Repo.get_by(Hero, hero_id: hero.id) do
      nil ->
        %Hero{}
          |> Hero.changeset(attributes)
          |> Repo.insert!
      record ->
        record
          |> Hero.changeset(attributes)
          |> Repo.update!
    end
  end

  def attributes(%HeroModel{} = hero) do
    %{
      hero_id: hero.id,
      name: hero.name,
      hero_name: hero.hero_name,
      localized_name: hero.localized_name,
      avatars: %{
        small_horizontal: hero.avatars[:small_horizontal],
        large_orizontal: hero.avatars[:large_orizontal],
        full_quality_horizontal: hero.avatars[:full_quality_horizontal],
        full_quality_vertical: hero.avatars[:full_quality_vertical]
      }
    }
  end
end
