defmodule NflRushing.Exporters.CSV do
  @moduledoc "Exports rushing statistics as CSV"

  @header [
    "Player",
    "Team",
    "Pos",
    "Att/G",
    "Att",
    "Yds",
    "Avg",
    "Yds/G",
    "Td",
    "Lng",
    "1st",
    "1st%",
    "20+",
    "40+",
    "FUM"
  ]

  alias NflRushing.Repo
  alias NflRushing.RushingStatisticRepository
  alias NflRushing.Schema.RushingStatistic

  @type export_options :: %{
          optional(:filter) => RushingStatisticRepository.filter(),
          optional(:sort_options) => RushingStatisticRepository.sort_options()
        }

  @doc """
  Accepts filtering and ordering options to query `NflRushing.Schema.RushingStatistic` and
  streams its data as CSV to given `callback` function.
  """
  @spec export(options :: export_options(), callback :: fun()) :: any()
  def export(options, callback) do
    Repo.transaction(
      fn ->
        options
        |> RushingStatisticRepository.list_stream()
        |> Stream.map(&build_row/1)
        |> add_header()
        |> NimbleCSV.RFC4180.dump_to_stream()
        |> callback.()
      end,
      timeout: :infinity
    )
  end

  defp add_header(stream),
    do: Stream.concat([@header], stream)

  defp build_row(rushing_statistic) do
    [
      rushing_statistic.player_name,
      rushing_statistic.team,
      rushing_statistic.player_position,
      rushing_statistic.attempts_per_game_average,
      rushing_statistic.attempts,
      rushing_statistic.total_yards,
      rushing_statistic.average_yards_per_attempt,
      rushing_statistic.yards_per_game,
      rushing_statistic.total_touchdowns,
      RushingStatistic.longest_rush(rushing_statistic),
      rushing_statistic.first_downs,
      rushing_statistic.first_down_percentage,
      rushing_statistic.above_twenty_yards,
      rushing_statistic.above_forty_yards,
      rushing_statistic.fumbles
    ]
  end
end
