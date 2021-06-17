defmodule NflRushing.RushingStatisticRepository do
  @moduledoc "Handles `NflRushing.Schema.RushingStatistic` querying."

  alias NflRushing.Repo
  alias NflRushing.Schema.RushingStatistic

  import Ecto.Query

  @type filter_criteria :: {:filter, %{optional(:player_name) => String.t()}}
  @type sort_criteria ::
          {:sort, %{optional(:sort_by) => atom(), optional(:sort_order) => :asc | :desc}}
  @type paginate_criteria ::
          {:paginate, %{required(:per_page) => pos_integer(), required(:page) => pos_integer()}}

  @doc """
  Returns a list with paginated `NflRushing.Schema.RushingStatistic` matching given criterias

  Example criteria:

  [
    filter: %{player_name: "pa"},
    paginate: %{page: 2, per_page: 10},
    sort: %{sort_by: :total_touchdowns, sort_order: :asc}
  ]
  """
  @spec list(criteria :: [filter_criteria() | sort_criteria() | paginate_criteria()]) ::
          Paginator.Page.t()
  def list(criteria \\ []) when is_list(criteria) do
    per_page = get_in(criteria, [:paginate, :per_page]) || 10

    criteria
    |> Enum.reduce(RushingStatistic, fn
      {:paginate, paginate_params}, query ->
        apply_pagination(query, paginate_params)

      {:filter, filter_params}, query ->
        apply_filter(query, filter_params)

      {:sort, sort_params}, query ->
        apply_sort(query, sort_params)
    end)
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: per_page)
  end

  defp apply_pagination(query, %{page: page, per_page: per_page}) do
    offset(query, ^((page - 1) * per_page))
  end

  defp apply_filter(query, %{player_name: player_name}),
    do: where(query, [r], like(r.player_name, ^"%#{player_name}%"))

  defp apply_filter(query, _assigns), do: query

  defp apply_sort(query, sort_params) do
    sort_by = sort_params[:sort_by] || :inserted_at
    sort_order = sort_params[:sort_order] || :asc

    order_by(query, [r], {^sort_order, ^sort_by})
  end

  @doc """
  Returns a `NflRushing.Schema.RushingStatistic` stream matching given criterias

  Example criteria:

  [
    filter: %{player_name: "pa"},
    sort: %{sort_by: :total_touchdowns, sort_order: :asc}
  ]
  """
  @spec list_stream(criteria :: [filter_criteria() | sort_criteria()]) :: Enum.t()
  def list_stream(criteria \\ []) when is_list(criteria) do
    criteria
    |> Enum.reduce(RushingStatistic, fn
      {:filter, filter_params}, query ->
        apply_filter(query, filter_params)

      {:sort, sort_params}, query ->
        apply_sort(query, sort_params)
    end)
    |> Repo.stream()
  end
end
