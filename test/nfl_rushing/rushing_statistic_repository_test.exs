defmodule NflRushing.RushingStatisticRepositoryTest do
  use NflRushing.DataCase

  alias NflRushing.RushingStatisticRepository

  describe "list/1" do
    test "returns rushing statistics" do
      rushing_statistics = insert_list(3, :rushing_statistic)

      assert ^rushing_statistics = RushingStatisticRepository.list()
    end

    test "filters by partial player name" do
      insert_list(3, :rushing_statistic)
      packer_statistic = insert(:rushing_statistic, player_name: "Gabriel Packer")
      parker_statistic = insert(:rushing_statistic, player_name: "Peter Parker")

      assert [^packer_statistic, ^parker_statistic] =
               RushingStatisticRepository.list(%{filter: %{player_name: "pa"}})
    end

    test "ignores other filters" do
      stone = insert(:rushing_statistic, team: "StoneCo")
      the_score = insert(:rushing_statistic, team: "theScore")

      assert [^stone, ^the_score] =
               RushingStatisticRepository.list(%{filter: %{team: "theScore"}})
    end

    test "sort by total_yards" do
      hundred_yards = insert(:rushing_statistic, total_yards: 100)
      sixty_yards = insert(:rushing_statistic, total_yards: 60)
      thirty_yards = insert(:rushing_statistic, total_yards: 30)

      assert [^thirty_yards, ^sixty_yards, ^hundred_yards] =
               RushingStatisticRepository.list(%{sort_options: %{sort_by: :total_yards}})

      assert [^thirty_yards, ^sixty_yards, ^hundred_yards] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :total_yards, sort_order: :asc}
               })

      assert [^hundred_yards, ^sixty_yards, ^thirty_yards] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :total_yards, sort_order: :desc}
               })
    end

    test "sort by total_touchdowns" do
      hundred_touchdowns = insert(:rushing_statistic, total_touchdowns: 100)
      sixty_touchdowns = insert(:rushing_statistic, total_touchdowns: 60)
      thirty_touchdowns = insert(:rushing_statistic, total_touchdowns: 30)

      assert [^thirty_touchdowns, ^sixty_touchdowns, ^hundred_touchdowns] =
               RushingStatisticRepository.list(%{sort_options: %{sort_by: :total_touchdowns}})

      assert [^thirty_touchdowns, ^sixty_touchdowns, ^hundred_touchdowns] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :total_touchdowns, sort_order: :asc}
               })

      assert [^hundred_touchdowns, ^sixty_touchdowns, ^thirty_touchdowns] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :total_touchdowns, sort_order: :desc}
               })
    end

    test "sort by longest_rush" do
      hundred_yards_rush = insert(:rushing_statistic, longest_rush: 100)
      sixty_yards_rush = insert(:rushing_statistic, longest_rush: 60)
      thirty_yards_rush = insert(:rushing_statistic, longest_rush: 30)

      assert [^thirty_yards_rush, ^sixty_yards_rush, ^hundred_yards_rush] =
               RushingStatisticRepository.list(%{sort_options: %{sort_by: :longest_rush}})

      assert [^thirty_yards_rush, ^sixty_yards_rush, ^hundred_yards_rush] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :longest_rush, sort_order: :asc}
               })

      assert [^hundred_yards_rush, ^sixty_yards_rush, ^thirty_yards_rush] =
               RushingStatisticRepository.list(%{
                 sort_options: %{sort_by: :longest_rush, sort_order: :desc}
               })
    end
  end

  describe "list_stream/1" do
    test "behaves the same" do
      insert_list(3, :rushing_statistic)

      packer_statistic =
        insert(:rushing_statistic, player_name: "Gabriel Packer", total_touchdowns: 20)

      parker_statistic =
        insert(:rushing_statistic, player_name: "Peter Parker", total_touchdowns: 10)

      assert {:ok, [^parker_statistic, ^packer_statistic]} =
               Repo.transaction(fn ->
                 %{
                   filter: %{player_name: "pa"},
                   sort_options: %{sort_by: :total_touchdowns, sort_order: :asc}
                 }
                 |> RushingStatisticRepository.list_stream()
                 |> Enum.to_list()
               end)
    end
  end
end
