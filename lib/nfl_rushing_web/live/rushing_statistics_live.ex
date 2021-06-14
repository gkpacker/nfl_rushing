defmodule NflRushingWeb.RushingStatisticsLive do
  @moduledoc false
  use NflRushingWeb, :live_view

  import NflRushingWeb.RushingStatisticsHelpers

  @impl true
  def mount(_params, _session, socket) do
    rushing_statistics = NflRushingWeb.list_rushing_statistics(%{})

    {:ok, socket, temporary_assigns: [rushing_statistics: rushing_statistics, options: %{}]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    options = options(params)

    rushing_statistics =
      options
      |> map_sort_by_to_domain()
      |> NflRushingWeb.list_rushing_statistics()

    {:noreply, assign(socket, rushing_statistics: rushing_statistics, options: options)}
  end

  defp options(params) do
    sort_by = params["sort_by"]
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()
    player = params["player"] || ""

    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    filter = %{player_name: player}

    %{
      sort_options: sort_options,
      filter: filter
    }
  end

  defp map_sort_by_to_domain(%{sort_options: %{sort_by: sort_by}} = options), do:
    put_in(options, [:sort_options, :sort_by], sort_by(sort_by))

  defp sort_by("Yds"), do: :total_yards
  defp sort_by("Td"), do: :total_touchdowns
  defp sort_by("Lng"), do: :longest_rush
  defp sort_by(_), do: :inserted_at
end
