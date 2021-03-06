defmodule NflRushingWeb.RushingStatisticsHelpers do
  @moduledoc "Provides helpers to display rushing statistics"

  def longest_rush(%{longest_rush: longest_rush, longest_rush_was_touchdown?: true}),
    do: "#{longest_rush}T"

  def longest_rush(%{longest_rush: longest_rush}), do: to_string(longest_rush)

  def toggle_sort_order(%{sort_order: "asc"}), do: "desc"
  def toggle_sort_order(%{sort_order: "desc"}), do: "asc"
  def toggle_sort_order(_), do: "desc"

  def sort_text(field, %{sort_by: field, sort_order: sort_order}),
    do: "#{field}#{sort_symbol(sort_order)}"

  def sort_text(field, _), do: field

  defp sort_symbol("asc"), do: "▲"
  defp sort_symbol("desc"), do: "▼"
end
