defmodule DotaLust.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dota_lust,
      version: "0.0.1",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {DotaLust, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :httpoison, :timex, :ex_machina, :dota2_api, :exq, :steam_id]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support", "test/factories"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 0.11.1"},
      {:wechat_applet, "~> 0.1.0"},
      {:dota2_api, "~> 0.1.0", github: "LcpMarvel/dota2_api"},
      {:exq, "~> 0.8.6"},
      {:timex, "~> 3.0"},
      {:ex_machina, "~> 2.0"},
      {:cowboy, "~> 1.0"},
      {:ecto_enum, "~> 1.0"},
      {:steam_id, "~> 0.1.0", github: "LcpMarvel/steam_id"},

      # dev
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], github: "jeremyjh/dialyxir"},

      # test
      {:exvcr, "~> 0.8", only: :test},
      {:meck, "0.8.4", only: :test},
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
