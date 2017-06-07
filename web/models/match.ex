defmodule DotaLust.Match do
  use DotaLust.Web, :model

  schema "matches" do
    field :match_id, :string
    field :sequence_number, :string
    field :season, :string
    field :winner, FactionEnum
    field :duration, :integer
    field :started_at, :naive_datetime
    field :tower_status_of_radiant, :string
    field :tower_status_of_dire, :string
    field :barracks_status_of_radiant, :string
    field :barracks_status_of_dire, :string
    field :server_cluster, :integer
    field :first_blood_occurred_at, :integer
    field :lobby_type, LobbyTypeEnum
    field :human_players_count, :integer
    field :league_id, :integer
    field :positive_votes_count, :integer
    field :negative_votes_count, :integer
    field :game_mode, GameModeEnum
    field :flags, :integer
    field :engine, :integer
    field :radiant_score, :integer
    field :dire_score, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:match_id, :sequence_number, :season, :winner, :duration, :started_at, :tower_status_of_radiant, :tower_status_of_dire, :barracks_status_of_radiant, :barracks_status_of_dire, :server_cluster, :first_blood_occurred_at, :lobby_type, :human_players_count, :league_id, :positive_votes_count, :negative_votes_count, :game_mode, :flags, :engine, :radiant_score, :dire_score])
    |> validate_required([:match_id, :sequence_number])
  end

  @spec existing_match_ids([String.t]) :: MapSet.t
  def existing_match_ids(ids) do
    from(m in __MODULE__, where: m.match_id in ^ids, select: m.match_id)
      |> Repo.all
      |> Enum.reduce(MapSet.new, fn(id, set) -> MapSet.put(set, id) end)
  end
end
