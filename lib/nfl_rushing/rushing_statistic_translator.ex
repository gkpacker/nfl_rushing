defmodule NflRushing.RushingStatisticTranslator do
  @moduledoc "Handles rushing statistic translation to domain"

  alias NflRushing.Schema.RushingStatistic

  @touchdown "T"

  @spec from_string_map(%{required(String.t()) => any()}) :: Ecto.Changeset.t()
  def from_string_map(rushing_statistic) when is_map(rushing_statistic) do
    params = %{
      player_name: rushing_statistic["Player"],
      team: rushing_statistic["Team"],
      player_position: rushing_statistic["Pos"],
      attempts: rushing_statistic["Att"],
      attempts_per_game_average: rushing_statistic["Att/G"],
      average_yards_per_attempt: rushing_statistic["Avg"],
      total_yards: yards(rushing_statistic["Yds"]),
      yards_per_game: ensure_float(rushing_statistic["Yds/G"]),
      total_touchdowns: rushing_statistic["TD"],
      longest_rush: longest_rush(rushing_statistic["Lng"]),
      longest_rush_was_touchdown?: longest_rush_was_touchdown?(rushing_statistic["Lng"]),
      first_downs: rushing_statistic["1st"],
      first_down_percentage: rushing_statistic["1st%"],
      above_twenty_yards: rushing_statistic["20+"],
      above_forty_yards: rushing_statistic["40+"],
      fumbles: rushing_statistic["FUM"]
    }

    RushingStatistic.changeset(%RushingStatistic{}, params)
  end

  defp ensure_float(numeric) when is_float(numeric), do: numeric
  defp ensure_float(numeric) when is_integer(numeric), do: numeric / 1

  defp longest_rush(longest_rush) when is_integer(longest_rush), do: longest_rush

  defp longest_rush(longest_rush) when is_binary(longest_rush),
    do:
      longest_rush
      |> String.replace(@touchdown, "")
      |> String.to_integer()

  defp longest_rush_was_touchdown?(longest_rush) when is_integer(longest_rush), do: false

  defp longest_rush_was_touchdown?(longest_rush) when is_binary(longest_rush),
    do: String.contains?(longest_rush, @touchdown)

  defp yards(yards) when is_integer(yards), do: yards

  defp yards(yards) when is_binary(yards),
    do: yards |> String.replace(",", "") |> String.to_integer()
end
