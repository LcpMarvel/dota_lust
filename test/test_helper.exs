ExUnit.configure(timeout: :infinity)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(DotaLust.Repo, :manual)

Application.ensure_all_started(:ex_machina)

:meck.new(Exq)
:meck.expect(Exq, :enqueue, fn(_, _, _, _) -> :ok end)
true = :meck.validate(Exq)
