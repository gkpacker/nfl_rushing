defmodule NflRushingWeb.RushingStatisticsLiveTest do
  use NflRushingWeb.ConnCase

  import NflRushing.Factory
  import Phoenix.LiveViewTest

  test "download csv button redirects to correct path", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("a", "Lng")
    |> render_click()

    view
    |> form("#player_name", player_name: "pa")
    |> render_change()

    view
    |> element("a", "Download CSV")
    |> render_click()

    assert_redirected(view, "/export_csv?sort_by=Lng&sort_order=desc&player_name=pa")
  end

  test "filter rushing statistics by player name", %{conn: conn} do
    insert(:rushing_statistic, player_name: "Gabriel Packer")
    insert(:rushing_statistic, player_name: "Junin")

    {:ok, view, _html} = live(conn, "/")

    view_html =
      view
      |> form("#player_name", player_name: "pa")
      |> render_change()

    assert view_html =~ "Gabriel Packer"
    refute view_html =~ "Junin"
  end

  test "orders by Td", %{conn: conn} do
    rushing_statistic = insert(:rushing_statistic, total_touchdowns: 100)
    another_rushing_statistic = insert(:rushing_statistic, total_touchdowns: 50)

    {:ok, view, _html} = live(conn, "/")

    view
    |> element("a", "Td")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", another_rushing_statistic.player_name)
           |> has_element?()

    view
    |> element("a", "Td")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", another_rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", rushing_statistic.player_name)
           |> has_element?()
  end

  test "orders by Yds", %{conn: conn} do
    rushing_statistic = insert(:rushing_statistic, total_yards: 100)
    another_rushing_statistic = insert(:rushing_statistic, total_yards: 50)

    {:ok, view, _html} = live(conn, "/")

    view
    |> element("a", "Yds")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", another_rushing_statistic.player_name)
           |> has_element?()

    view
    |> element("a", "Yds")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", another_rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", rushing_statistic.player_name)
           |> has_element?()
  end

  test "orders by Lng", %{conn: conn} do
    rushing_statistic = insert(:rushing_statistic, longest_rush: 100)
    another_rushing_statistic = insert(:rushing_statistic, longest_rush: 50)

    {:ok, view, _html} = live(conn, "/")

    view
    |> element("a", "Lng")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", another_rushing_statistic.player_name)
           |> has_element?()

    view
    |> element("a", "Lng")
    |> render_click()

    assert view
           |> element("#rushing_statistic-0", another_rushing_statistic.player_name)
           |> has_element?()

    assert view
           |> element("#rushing_statistic-1", rushing_statistic.player_name)
           |> has_element?()
  end

  test "has pagination", %{conn: conn} do
    rushing_statistic = insert(:rushing_statistic)
    another_rushing_statistic = insert(:rushing_statistic)

    {:ok, view, html} = live(conn, "/?per_page=1")

    assert html =~ rushing_statistic.player_name
    refute html =~ another_rushing_statistic.player_name

    html =
      view
      |> element("a", "Next")
      |> render_click()

    refute html =~ rushing_statistic.player_name
    assert html =~ another_rushing_statistic.player_name

    html =
      view
      |> element("a", "Previous")
      |> render_click()

    assert html =~ rushing_statistic.player_name
    refute html =~ another_rushing_statistic.player_name
  end
end
