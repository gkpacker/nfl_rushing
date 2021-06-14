defmodule NflRushingWeb.RushingStatisticsHelpersTest do
  use ExUnit.Case

  alias NflRushingWeb.RushingStatisticsHelpers

  describe "longest_rush/1" do
    test "returns longest rush" do
      assert "30" =
               RushingStatisticsHelpers.longest_rush(%{
                 longest_rush: 30,
                 longest_rush_was_touchdown?: false
               })

      assert "40" = RushingStatisticsHelpers.longest_rush(%{longest_rush: 40})
    end

    test "returns longest rush with a T if it's a touchdown" do
      assert "20T" =
               RushingStatisticsHelpers.longest_rush(%{
                 longest_rush: 20,
                 longest_rush_was_touchdown?: true
               })
    end
  end

  describe "toggle_sort_order/1" do
    test "returns :asc if it's :desc" do
      assert :asc = RushingStatisticsHelpers.toggle_sort_order(%{sort_options: %{sort_order: :desc}})
    end

    test "returns :desc if it's :asc" do
      assert :desc = RushingStatisticsHelpers.toggle_sort_order(%{sort_options: %{sort_order: :asc}})
    end

    test "defaults to :asc" do
      assert :asc = RushingStatisticsHelpers.toggle_sort_order(%{})
    end
  end
end