defmodule NflRushing.Repo.Migrations.CreateRushingStatistics do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION citext"

    create table(:rushing_statistics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player_name, :citext, null: false
      add :team, :string, null: false
      add :player_position, :string, null: false
      add :attempts, :integer, null: false
      add :attempts_per_game_average, :float, null: false
      add :total_yards, :integer, null: false
      add :average_yards_per_attempt, :float, null: false
      add :yards_per_game, :float, null: false
      add :total_touchdowns, :integer, null: false
      add :longest_rush, :integer, null: false
      add :longest_rush_was_touchdown?, :boolean, null: false, default: false
      add :first_downs, :integer, null: false
      add :first_down_percentage, :float, null: false
      add :above_twenty_yards, :integer, null: false
      add :above_forty_yards, :integer, null: false
      add :fumbles, :integer, null: false

      timestamps()
    end
  end

  def down do
    drop table(:rushing_statistics)

    execute "DROP EXTENSION citext"
  end
end
