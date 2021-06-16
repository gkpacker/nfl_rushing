defmodule NflRushing.Exporters.CSVTest do
  use NflRushing.DataCase

  alias NflRushing.Exporters.CSV

  describe "export" do
    test "exports rushing statistics to csv" do
      %{
        player_name: player_name,
        team: team,
        player_position: player_position,
        attempts_per_game_average: attempts_per_game_average,
        attempts: attempts,
        total_yards: total_yards,
        average_yards_per_attempt: average_yards_per_attempt,
        yards_per_game: yards_per_game,
        total_touchdowns: total_touchdowns,
        longest_rush: longest_rush,
        first_downs: first_downs,
        first_down_percentage: first_down_percentage,
        above_twenty_yards: above_twenty_yards,
        above_forty_yards: above_forty_yards,
        fumbles: fumbles
      } = insert(:rushing_statistic, longest_rush_was_touchdown?: true)

      {:ok, iodata} = CSV.export(%{}, fn stream -> Enum.to_list(stream) end)

      assert IO.iodata_to_binary(iodata) == """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{player_name},#{team},#{player_position},#{attempts_per_game_average},#{attempts},#{
               total_yards
             },#{average_yards_per_attempt},#{yards_per_game},#{total_touchdowns},#{longest_rush}T,#{
               first_downs
             },#{first_down_percentage},#{above_twenty_yards},#{above_forty_yards},#{fumbles}\r\n\
             """
    end
  end
end
