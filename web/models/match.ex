defmodule DotaLust.Match do
  use DotaLust.Web, :model

  alias DotaLust.Player

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

    has_many :players, Player, references: :match_id, foreign_key: :match_id
    has_many :picks_bans, DotaLust.PickBan, references: :match_id, foreign_key: :match_id
  end

  def changeset(struct, params \\ %{}) do
    attributes = [
      :match_id, :sequence_number, :season, :winner, :duration,
      :started_at, :tower_status_of_radiant, :tower_status_of_dire,
      :barracks_status_of_radiant, :barracks_status_of_dire, :server_cluster,
      :first_blood_occurred_at, :lobby_type, :human_players_count, :league_id,
      :positive_votes_count, :negative_votes_count, :game_mode, :flags, :engine,
      :radiant_score, :dire_score
    ]

    struct
      |> cast(params, attributes)
      |> validate_required([:match_id, :sequence_number])
      |> cast_assoc(:players, required: true)
      |> cast_assoc(:picks_bans, required: false)
  end

  @spec existing_match_ids_query([String.t]) :: Ecto.Query.t
  def existing_match_ids_query(ids) do
    from m in __MODULE__, where: m.match_id in ^ids, select: m.match_id
  end

  @spec account_id_scope(Ecto.Query.t, [String.t]) :: Ecto.Query.t
  def account_id_scope(scope, account_id) do
    from m in scope,
      join: p in Player, on: p.match_id == m.match_id,
      where: p.account_id == ^account_id,
      select: m
  end

  @spec recent(Ecto.Query.t) :: Ecto.Query.t
  def recent(scope, count \\ 20) do
    from m in scope, limit: ^count, order_by: [desc: m.match_id]
  end
end
