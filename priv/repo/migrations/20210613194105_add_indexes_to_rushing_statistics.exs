defmodule NflRushing.Repo.Migrations.AddIndexesToRushingStatistics do
  use Ecto.Migration

  def change do
    create index(:rushing_statistics, [:total_yards])
    create index(:rushing_statistics, [:longest_rush])
    create index(:rushing_statistics, [:total_touchdowns])
  end
end
