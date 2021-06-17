defmodule NflRushing.Repo.Migrations.AddCursorIndexToRushingStatistics do
  use Ecto.Migration

  def change do
    create index(:rushing_statistics, [:inserted_at])
    create index(:rushing_statistics, [:inserted_at, :id])
  end
end
