defmodule NflRushing.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: NflRushing.Repo

  alias NflRushing.Schema.RushingStatistic

  def rushing_statistic_factory do
    %RushingStatistic{
      above_forty_yards: :rand.uniform(100),
      above_twenty_yards: :rand.uniform(100),
      attempts: :rand.uniform(100),
      attempts_per_game_average: random_float(),
      average_yards_per_attempt: random_float(),
      first_down_percentage: random_float(),
      first_downs: :rand.uniform(100),
      fumbles: :rand.uniform(100),
      longest_rush: :rand.uniform(100),
      longest_rush_was_touchdown?: false,
      player_name: "Brandon McManus #{:rand.uniform(10000)}",
      player_position: "K",
      team: "DEN",
      total_touchdowns: :rand.uniform(100),
      total_yards: :rand.uniform(100),
      yards_per_game: random_float()
    }
  end

  defp random_float, do: :rand.uniform(100) / 1
end
