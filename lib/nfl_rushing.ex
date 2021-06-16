defmodule NflRushing do
  @moduledoc """
  NflRushing keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias NflRushing.Exporters.CSV
  alias NflRushing.RushingStatisticRepository

  defdelegate list_rushing_statistics(options \\ %{}), to: RushingStatisticRepository, as: :list
  defdelegate export_csv(options \\ %{}, callback), to: CSV, as: :export
end
