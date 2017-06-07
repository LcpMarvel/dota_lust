defmodule DotaLust.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %DotaLust.User{
          nick_name: "Micheal",
          wechat_open_id: "oHH3q0LXCSeCCc7JhDhITMuSkauE",
          gender: true,
          avatar_url: "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83erDCM1NdGicg4tvIEwHicOrQyt5X3ytjKmW7PRHmCreFUwFibYA8QbYDOb6KPBz5rbJF5ibmibEJYjhpiaA/0",
          country: "CN",
          province: "Zhejiang",
          city: "Hangzhou"
        }
      end
    end
  end
end
