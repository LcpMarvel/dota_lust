defmodule DotaLust.SteamAccountFactory do
  defmacro __using__(_opts) do
    quote do
      def steam_account_factory do
        %DotaLust.SteamAccount{
          user: build(:user),
          account_id: "275477134"
        }
      end
    end
  end
end
