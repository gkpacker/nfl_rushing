defmodule NflRushingTest do
  use NflRushing.DataCase

  alias NflRushing

  describe "list_rushing_statistics/1" do
    test "returns rushing statistics" do
      assert %{entries: []} = NflRushing.list_rushing_statistics()

      rushing_statistic = insert(:rushing_statistic)

      assert %{entries: [^rushing_statistic]} = NflRushing.list_rushing_statistics()
    end

    test "accepts filter and sort options" do
      insert(:rushing_statistic)

      packer_statistic =
        insert(:rushing_statistic, total_yards: 20, player_name: "Gabriel Packer")

      parker_statistic = insert(:rushing_statistic, total_yards: 30, player_name: "Peter Parker")

      assert %{entries: [^parker_statistic, ^packer_statistic]} =
               NflRushing.list_rushing_statistics(
                 filter: %{player_name: "pa"},
                 sort: %{sort_by: :total_yards, sort_order: :desc}
               )
    end
  end
end
