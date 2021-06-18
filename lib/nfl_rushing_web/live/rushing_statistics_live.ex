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
    paginate = paginate_options(params)

    %{entries: rushing_statistics} =
      NflRushingWeb.list_rushing_statistics(
        filter: %{player_name: player_name},
        sort: sort_options,
        paginate: paginate
      )

    socket =
      assign(socket,
        rushing_statistics: rushing_statistics,
        sort_options: sort_options,
        player_name: player_name,
        paginate: paginate
      )

    {:noreply, socket}
  end

  defp paginate_options(params) do
    page = String.to_integer(params["page"] || "1")
    per_page_params = String.to_integer(params["per_page"] || "10")

    per_page = if(per_page_params > 50, do: 50, else: per_page_params)

    %{page: page, per_page: per_page}
  end

  @impl true
  def handle_event("filter", %{"player_name" => player_name}, socket) do
    {:noreply, push_patch(socket, to: self_path(socket, %{player_name: player_name}))}
  end

  @impl true
  def handle_event("change-per-page", %{"per-page" => per_page}, socket) do
    {:noreply, push_patch(socket, to: self_path(socket, %{per_page: per_page}))}
  end

  defp pagination_link(socket, text, opts) do
    live_patch(text,
      to:
        Routes.rushing_statistics_path(
          socket,
          :index,
          opts
        )
    )
  end

  def self_path(socket, extra) do
    opts = options(socket)

    Routes.rushing_statistics_path(
      socket,
      :index,
      Map.merge(opts, extra)
    )
  end

  defp options(socket) do
    socket.assigns.sort_options
    |> Map.put(:player_name, socket.assigns.player_name)
    |> Map.put(:per_page, socket.assigns.paginate.per_page)
    |> Map.put(:page, socket.assigns.paginate.page)
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.into(%{})
  end

  defp sort_options(params) do
    sort_by = params["sort_by"]
    sort_order = params["sort_order"]

    %{sort_by: sort_by, sort_order: sort_order}
  end
end
