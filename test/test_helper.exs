ExUnit.configure(timeout: :infinity)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(DotaLust.Repo, :manual)

Application.ensure_all_started(:ex_machina)
