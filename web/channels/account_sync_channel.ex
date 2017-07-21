defmodule DotaLust.AccountSyncChannel do
  use Phoenix.Channel
  require Logger
  alias DotaLust.Worker.Dota2API.DetailWorker

  def join("account_sync:" <> steam_account_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_progress", _message, socket) do
    percent = DetailWorker.current_progress(socket.topic)

    {:reply, {:ok, %{percent: percent}}, socket}
  end

  def terminate(_reason, _socket) do
    :ok
  end

  def channel(steam_account_id) do
    "account_sync:#{steam_account_id}"
  end
end
