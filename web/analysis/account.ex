defmodule DotaLust.Analysis.Account do
  alias DotaLust.Repo

  alias DotaLust.Player

  @spec winning_percentage(String.t) :: float
  def winning_percentage(account_id) do
    case matches_count(account_id) do
      0 ->
        0.0
      matches_count ->
        win_count = matches_win_count(account_id)

        Float.round(win_count / matches_count * 100, 2)
    end
  end

  @spec matches_count(String.t) :: integer
  def matches_count(account_id) do
    account_id
      |> Player.by_account_id
      |> Repo.aggregate(:count, :id)
  end

  @spec matches_win_count(String.t) :: integer
  def matches_win_count(account_id) do
    account_id
      |> Player.by_account_id
      |> Player.win_scope
      |> Repo.aggregate(:count, :id)
  end
end
