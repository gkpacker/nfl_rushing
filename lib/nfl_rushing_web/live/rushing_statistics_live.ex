defmodule NflRushingWeb.RushingStatisticsLive do
  @moduledoc false
  use NflRushingWeb, :live_view

  import NflRushingWeb.RushingStatisticsHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [rushing_statistics: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    sort_options = sort_options(params)
    player_name = params["player_name"]

    rushing_statistics =
      NflRushingWeb.list_rushing_statistics(%{
        filter: %{player_name: player_name},
        sort_options: sort_options
      })

    socket =
      assign(socket,
        rushing_statistics: rushing_statistics,
        sort_options: sort_options,
        player_name: player_name
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("filter", %{"player_name" => player_name}, socket) do
    {:noreply, push_patch(socket, to: self_path(socket, player_name))}
  end

  def self_path(socket, player_name) do
    Routes.rushing_statistics_path(
      socket,
      :index,
      Map.put(socket.assigns.sort_options, :player_name, player_name)
    )
  end

  defp sort_options(params) do
    sort_by = params["sort_by"]
    sort_order = (params["sort_order"] || "desc") |> String.to_atom()

    %{sort_by: sort_by, sort_order: sort_order}
  end
end
