defmodule NflRushingWeb.RushingStatisticsControllerTest do
  use NflRushingWeb.ConnCase

  describe "export_csv" do
    test "returns data ordered desc for better user experience", %{conn: conn} do
      hundred_yards = insert(:rushing_statistic, total_yards: 100)
      fifty_yards = insert(:rushing_statistic, total_yards: 50)
      zero_yards = insert(:rushing_statistic, total_yards: 0)

      conn = get(conn, Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Yds"}))

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{rushing_statistic_lines([hundred_yards, fifty_yards, zero_yards])}\
             """
    end

    test "returns data ordered by Yds asc", %{conn: conn} do
      hundred_yards = insert(:rushing_statistic, total_yards: 100)
      fifty_yards = insert(:rushing_statistic, total_yards: 50)
      zero_yards = insert(:rushing_statistic, total_yards: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Yds", sort_order: "asc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{rushing_statistic_lines([zero_yards, fifty_yards, hundred_yards])}\
             """
    end

    test "returns data ordered by Yds desc", %{conn: conn} do
      hundred_yards = insert(:rushing_statistic, total_yards: 100)
      fifty_yards = insert(:rushing_statistic, total_yards: 50)
      zero_yards = insert(:rushing_statistic, total_yards: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Yds", sort_order: "desc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{rushing_statistic_lines([hundred_yards, fifty_yards, zero_yards])}\
             """
    end

    test "returns data ordered by Td desc", %{conn: conn} do
      hundred_touchdowns = insert(:rushing_statistic, total_touchdowns: 100)
      fifty_touchdowns = insert(:rushing_statistic, total_touchdowns: 50)
      zero_touchdowns = insert(:rushing_statistic, total_touchdowns: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Td", sort_order: "desc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{rushing_statistic_lines([hundred_touchdowns, fifty_touchdowns, zero_touchdowns])}\
             """
    end

    test "returns data ordered by Td asc", %{conn: conn} do
      hundred_touchdowns = insert(:rushing_statistic, total_touchdowns: 100)
      fifty_touchdowns = insert(:rushing_statistic, total_touchdowns: 50)
      zero_touchdowns = insert(:rushing_statistic, total_touchdowns: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Td", sort_order: "asc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{rushing_statistic_lines([zero_touchdowns, fifty_touchdowns, hundred_touchdowns])}\
             """
    end

    test "returns data ordered by Lng desc", %{conn: conn} do
      hundred_yards_longest_rush = insert(:rushing_statistic, longest_rush: 100)
      fifty_yards_longest_rush = insert(:rushing_statistic, longest_rush: 50)
      zero_yards_longest_rush = insert(:rushing_statistic, longest_rush: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Lng", sort_order: "desc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{
               rushing_statistic_lines([
                 hundred_yards_longest_rush,
                 fifty_yards_longest_rush,
                 zero_yards_longest_rush
               ])
             }\
             """
    end

    test "returns data ordered by Lng asc", %{conn: conn} do
      hundred_yards_longest_rush = insert(:rushing_statistic, longest_rush: 100)
      fifty_yards_longest_rush = insert(:rushing_statistic, longest_rush: 50)
      zero_yards_longest_rush = insert(:rushing_statistic, longest_rush: 0)

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{sort_by: "Lng", sort_order: "asc"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{
               rushing_statistic_lines([
                 zero_yards_longest_rush,
                 fifty_yards_longest_rush,
                 hundred_yards_longest_rush
               ])
             }\
             """
    end

    test "filter by partial player name", %{conn: conn} do
      packer_statistic = insert(:rushing_statistic, player_name: "Gabriel Packer")
      parker_statistic = insert(:rushing_statistic, player_name: "Peter Parker")
      insert(:rushing_statistic, player_name: "Jofrey")

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{player_name: "pa"})
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{
               rushing_statistic_lines([
                 packer_statistic,
                 parker_statistic
               ])
             }\
             """
    end

    test "filter by partial player name, sorted by Td asc", %{conn: conn} do
      packer_statistic =
        insert(:rushing_statistic, player_name: "Gabriel Packer", total_touchdowns: 100)

      # I'm better than peter parker

      parker_statistic =
        insert(:rushing_statistic, player_name: "Peter Parker", total_touchdowns: 99)

      insert(:rushing_statistic, player_name: "Jofrey")

      conn =
        get(
          conn,
          Routes.rushing_statistics_path(conn, :export_csv, %{
            player_name: "pa",
            sort_order: "asc",
            sort_by: "Td"
          })
        )

      data = response(conn, 200)

      assert data =~ """
             Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,Td,Lng,1st,1st%,20+,40+,FUM\r\n\
             #{
               rushing_statistic_lines([
                 parker_statistic,
                 packer_statistic
               ])
             }\
             """
    end
  end

  defp rushing_statistic_lines(rushing_statistics) do
    rushing_statistics
    |> Enum.map(&rushing_statistic_to_csv/1)
    |> NimbleCSV.RFC4180.dump_to_iodata()
  end

  defp rushing_statistic_to_csv(rushing_statistic) do
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
      "#{rushing_statistic.longest_rush}#{
        if(rushing_statistic.longest_rush_was_touchdown?, do: "T")
      }",
      rushing_statistic.first_downs,
      rushing_statistic.first_down_percentage,
      rushing_statistic.above_twenty_yards,
      rushing_statistic.above_forty_yards,
      rushing_statistic.fumbles
    ]
  end
end
