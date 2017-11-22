defmodule DotaLust.UserSteamAccountFactory do
  defmacro __using__(_opts) do
    quote do
      def user_steam_account_factory do
        %DotaLust.UserSteamAccount {
          steam_account: build(:steam_account),
          user: build(:user),
          default: true
        }
      end
    end
  end
end
