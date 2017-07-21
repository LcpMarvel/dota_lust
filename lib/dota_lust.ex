defmodule DotaLust do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(DotaLust.Repo, []),
      # Start the endpoint when the application starts
      supervisor(DotaLust.Endpoint, []),
      # Start your own worker by calling: DotaLust.Worker.start_link(arg1, arg2, arg3)
      # worker(DotaLust.Worker, [arg1, arg2, arg3]),
      worker(Redix, redix_args())
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DotaLust.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DotaLust.Endpoint.config_change(changed, removed)
    :ok
  end

  def redix_args do
    [
      [
        host: Application.fetch_env!(:dota_lust, :redix_host),
        port: Application.fetch_env!(:dota_lust, :redix_port)
      ],
      [
        name: :redix
      ]
    ]
  end
end
