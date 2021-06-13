defmodule NflRushing.RushingStatisticTranslatorTest do
  use NflRushing.DataCase

  alias NflRushing.RushingStatisticTranslator
  alias NflRushing.Schema.RushingStatistic

  @rushing_statistic_string_map %{
    "Player" => "Robert Griffin III",
    "Team" => "CLE",
    "Pos" => "QB",
    "Att" => 31,
    "Att/G" => 6.2,
    "Yds" => "190",
    "Avg" => 6.1,
    "Yds/G" => 38,
    "TD" => 2,
    "Lng" => "20",
    "1st" => 10,
    "1st%" => 32.3,
    "20+" => 1,
    "40+" => 0,
    "FUM" => 2
  }

  describe "from_string_map/1" do
    test "translates to a domain rushing statistic" do
      assert %Ecto.Changeset{valid?: true} =
               changeset =
               RushingStatisticTranslator.from_string_map(@rushing_statistic_string_map)

      assert %RushingStatistic{
               above_forty_yards: 0,
               above_twenty_yards: 1,
               attempts: 31,
               attempts_per_game_average: 6.2,
               average_yards_per_attempt: 6.1,
               first_down_percentage: 32.3,
               first_downs: 10,
               fumbles: 2,
               id: nil,
               inserted_at: nil,
               longest_rush: 20,
               longest_rush_was_touchdown?: false,
               player_name: "Robert Griffin III",
               player_position: "QB",
               team: "CLE",
               total_touchdowns: 2,
               total_yards: 190,
               updated_at: nil,
               yards_per_game: 38.0
             } = Ecto.Changeset.apply_changes(changeset)
    end

    test "parses longest rush" do
      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Lng", "20T")
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{longest_rush: 20, longest_rush_was_touchdown?: true} = rushing_statistic

      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Lng", "20")
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{longest_rush: 20, longest_rush_was_touchdown?: false} = rushing_statistic

      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Lng", 20)
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{longest_rush: 20, longest_rush_was_touchdown?: false} = rushing_statistic
    end

    test "parses yards" do
      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Yds", "1,000")
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{total_yards: 1000} = rushing_statistic

      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Yds", 1000)
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{total_yards: 1000} = rushing_statistic
    end

    test "ensures yards per game is float" do
      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Yds/G", 10)
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{yards_per_game: 10.0} = rushing_statistic

      rushing_statistic =
        @rushing_statistic_string_map
        |> Map.put("Yds/G", 10.0)
        |> RushingStatisticTranslator.from_string_map()
        |> Ecto.Changeset.apply_changes()

      assert %{yards_per_game: 10.0} = rushing_statistic
    end
  end
end
