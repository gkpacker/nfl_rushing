defmodule NflRushingWeb.RushingStatisticsHelpers do
  def longest_rush(%{longest_rush: longest_rush, longest_rush_was_touchdown?: true}),
    do: "#{longest_rush}T"

  def longest_rush(%{longest_rush: longest_rush}), do: longest_rush

  def toggle_sort_order(%{sort_options: %{sort_order: :asc}}), do: :desc
  def toggle_sort_order(%{sort_options: %{sort_order: :desc}}), do: :asc
  def toggle_sort_order(_), do: :asc

  def sort_text(field, %{sort_options: %{sort_by: field, sort_order: sort_order}}),
    do: "#{field}#{sort_symbol(sort_order)}"

  def sort_text(field, _), do: field

  defp sort_symbol(:asc), do: "▲"
  defp sort_symbol(:desc), do: "▼"
end
