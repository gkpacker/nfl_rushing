defmodule NflRushing.RushingStatisticRepository do
  @moduledoc "Handles `NflRushing.Schema.RushingStatistic` querying."

  alias NflRushing.Repo
  alias NflRushing.Schema.RushingStatistic

  import Ecto.Query

  @type filter :: %{optional(:player_name) => String.t()}
  @type sort_options :: %{optional(:sort_by) => atom(), optional(:sort_order) => :asc | :desc}
  @type list_options :: %{
          optional(:filter) => filter(),
          optional(:sort_options) => sort_options()
        }

  @doc """
  Returns a list with all `NflRushing.Schema.RushingStatistic` matching given criterias
  in `options[:filter]` and orders by `options[:sort_options][:sort_by]`
  in `options[:sort_options][:sort_order]` direction.
  """
  @spec list(options :: list_options()) :: [RushingStatistic.t()]
  def list(options \\ %{})

  def list(options) do
    options
    |> list_query()
    |> Repo.all()
  end

  @spec list_stream(options :: list_options()) :: Enum.t()
  def list_stream(options \\ %{})

  def list_stream(options) do
    options
    |> list_query()
    |> Repo.stream()
  end

  defp list_query(options) do
    filters = options[:filter] || %{}
    sort_by = get_in(options, [:sort_options, :sort_by]) || :inserted_at
    sort_order = get_in(options, [:sort_options, :sort_order]) || :asc

    filters
    |> Enum.reduce(RushingStatistic, &apply_filter/2)
    |> order_by([r], {^sort_order, ^sort_by})
  end

  defp apply_filter({:player_name, player_name}, query),
    do: where(query, [r], like(r.player_name, ^"%#{player_name}%"))

  defp apply_filter(_, query), do: query
end
