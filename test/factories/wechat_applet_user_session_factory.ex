defmodule DotaLust.WechatAppletUserSessionFactory do
  defmacro __using__(_opts) do
    quote do
      use Timex

      def wechat_applet_user_session_factory do
        %DotaLust.WechatAppletUserSession{
          wechat_open_id: "oHH3q0LXCSeCCc7JhDhITMuSkauE",
          session_key: "1zuOVQ5T32Ro9Ll5KkNkNg==",
          token: "FH/J6tUVp/0vPJOafI4Cpw==",
          expired_at: Timex.shift(Timex.now, days: 1),
          user: build(:user)
        }
      end
    end
  end
end
