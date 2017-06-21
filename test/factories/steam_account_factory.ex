defmodule DotaLust.SteamAccountFactory do
  defmacro __using__(_opts) do
    quote do
      def steam_account_factory do
        %DotaLust.SteamAccount{
          user: build(:user),
          account_id: "105248644",
          default: true
        }
      end
    end
  end
end
