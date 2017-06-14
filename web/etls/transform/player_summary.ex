defmodule DotaLust.ETL.Transform.PlayerSummary do
  alias Dota2API.Enum.CommunityVisibilityState
  alias Dota2API.Enum.PersonaState

  @type t :: [
    steam64_id: String.t,
    account_id: String.t,
    community_visibility_state: integer,
    display_name: String.t,
    last_sign_out_at: integer,
    profile_url: String.t,
    avatars: %{
      normal: String.t,
      full: String.t,
      medium: String.t
    },
    persona_state: integer,
    realname: String.t,
    created_at: DateTime.t
  ]

  @spec execute(Dota2API.Model.PlayerSummary.t) :: [t]
  def execute(player) do
    [
      steam64_id: player.steam64_id,
      account_id: player.account_id,
      community_visibility_state: CommunityVisibilityState.raw_value(player.community_visibility_state),
      display_name: player.display_name,
      last_sign_out_at: player.last_sign_out_at |> to_datetime,
      profile_url: player.profile_url,
      avatars: player.avatars,
      persona_state: PersonaState.raw_value(player.persona_state),
      realname: player.realname,
      created_at: player.created_at |> to_datetime
    ]
  end

  def to_datetime(timestamp) do
    if timestamp do
      DateTime.from_unix!(timestamp)
    end
  end
end

