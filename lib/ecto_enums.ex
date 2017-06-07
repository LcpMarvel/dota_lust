import EctoEnum

defenum FactionEnum, radiant: 0, dire: 1

defenum GameModeEnum, none: 0,
                      all_pick: 1,
                      captain_mode: 2,
                      random_draft: 3,
                      single_draft: 4,
                      all_random: 5,
                      intro: 6,
                      diretide: 7,
                      reverse_captain_mode: 8,
                      greeviling: 9,
                      tutorial: 10,
                      mid_only: 11,
                      least_played: 12,
                      new_player_pool: 13,
                      compendium_matchmaking: 14,
                      custom: 15,
                      captain_draft: 16,
                      balanced_draft: 17,
                      ability_draft: 18,
                      unknown_event: 19,
                      all_random_death_match: 20,
                      solo_mid: 21,
                      ranked_all_pick: 22

defenum LeaverStatusEnum, none: 0,
                          disconnected: 1,
                          disconnected_too_long: 2,
                          abandoned: 3,
                          afk: 4,
                          never_connected: 5,
                          never_connected_too_long: 6

defenum LobbyTypeEnum, invalid: -1,
                       public_matchmaking: 0,
                       practise: 1,
                       tournament: 2,
                       tutorial: 3,
                       cooperative_with_bots: 4,
                       team_match: 5,
                       solo_queue: 6,
                       ranked: 7,
                       one_vs_one_mid: 8

defenum SkillEnum, any: 0,
                   normal: 1,
                   high: 2,
                   very_high: 4
