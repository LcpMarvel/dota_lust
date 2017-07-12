defmodule DotaLust.Router do
  use DotaLust.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DotaLust do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/wechat", as: :wechat_api, alias: DotaLust.Wechat do
    pipe_through :api

    post "/login", SessionController, :create

    resources "/user", UserController, singleton: true, only: [:update]
    resources "/steam_accounts", SteamAccountController, only: [:create] do
      get "/summary", SteamAccountController, :summary
    end
    resources "/steam_account", SteamAccountController, only: [], singleton: true do
      get "/summary", SteamAccountController, :summary
    end
    resources "/matches", MatchController, only: [:index, :show]
  end
end
